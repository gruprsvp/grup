import 'package:collection/collection.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

import 'user_data.dart';

/// Schedules, and everyone's answers to them: replies to single occurrences,
/// and default rules that answer recurring occurrences in advance.
class SchedulesRepository extends UserData {
  SchedulesRepository({
    required SchedulesService schedules,
    required DefaultRulesService defaultRules,
    required RepliesService replies,
    required LocalCache cache,
  }) : _schedulesService = schedules,
       _defaultRulesService = defaultRules,
       _repliesService = replies,
       super(cache, cacheKey);

  /// Where the device copy lives in [LocalCache].
  static const cacheKey = 'schedules';

  final SchedulesService _schedulesService;
  final DefaultRulesService _defaultRulesService;
  final RepliesService _repliesService;

  Map<String, Schedule> _schedules = {};
  Map<String, DefaultRule> _defaultRules = {};
  Map<String, Reply> _replies = {};

  /// [groupId]'s schedules, earliest first.
  List<Schedule> schedules(String groupId) => _schedules.values
      .where((schedule) => schedule.groupId == groupId)
      .sortedBy((schedule) => schedule.startDate);

  Schedule? schedule(String id) => _schedules[id];

  /// The default rules of [groupId]'s schedules.
  List<DefaultRule> defaultRules(String groupId) => [
    for (final rule in _defaultRules.values)
      if (_schedules[rule.scheduleId]?.groupId == groupId) rule,
  ];

  /// The replies to [groupId]'s schedules, as of the last [load].
  List<Reply> replies(String groupId) => [
    for (final reply in _replies.values)
      if (_schedules[reply.scheduleId]?.groupId == groupId) reply,
  ];

  /// Reloads [groupId]'s schedules and default rules, and its replies within
  /// [window]. Replaces what is cached for the group, so whatever someone
  /// else deleted disappears; replies outside [window] are dropped.
  Future<Result<void>> load(String groupId, DateTimeRange window) {
    final generation = this.generation;
    return guard(() async {
      late final List<Schedule> schedules;
      late final List<DefaultRule> defaultRules;
      late final List<Reply> replies;
      await Future.wait([
        _schedulesService
            .getGroupSchedules(groupId)
            .then((value) => schedules = value),
        _defaultRulesService
            .getDefaultRules(groupId)
            .then((value) => defaultRules = value),
        _repliesService
            .getRepliesForDateRange(groupId, window)
            .then((value) => replies = value),
      ]);
      ifCurrent(generation, () {
        bool inGroup(String scheduleId) =>
            _schedules[scheduleId]?.groupId == groupId;
        _defaultRules = {
          for (final MapEntry(:key, :value) in _defaultRules.entries)
            if (!inGroup(value.scheduleId)) key: value,
          for (final rule in defaultRules) _ruleKey(rule): rule,
        };
        _replies = {
          for (final MapEntry(:key, :value) in _replies.entries)
            if (!inGroup(value.scheduleId)) key: value,
          for (final reply in replies) _replyKey(reply): reply,
        };
        _schedules = {
          for (final schedule in _schedules.values)
            if (schedule.groupId != groupId) schedule.id: schedule,
          for (final schedule in schedules) schedule.id: schedule,
        };
      });
    });
  }

  Future<Result<Schedule>> create(Schedule schedule) {
    final generation = this.generation;
    return guard(() async {
      final created = await _schedulesService.createSchedule(schedule);
      ifCurrent(generation, () {
        _schedules = {..._schedules, created.id: created};
      });
      return created;
    });
  }

  /// Deletes [schedule], with its default rules and replies.
  Future<Result<void>> delete(Schedule schedule) {
    final generation = this.generation;
    return guard(() async {
      await _schedulesService.deleteSchedule(schedule.id);
      ifCurrent(generation, () {
        _schedules = {..._schedules}..remove(schedule.id);
        _defaultRules.removeWhere((_, rule) => rule.scheduleId == schedule.id);
        _replies.removeWhere((_, reply) => reply.scheduleId == schedule.id);
      });
    });
  }

  /// Answers one occurrence for [memberId], or clears their answer when
  /// [option] is null.
  ///
  /// Shows up right away, and is undone if the server refuses it.
  Future<Result<void>> reply({
    required String memberId,
    required String scheduleId,
    required DateTime instanceDate,
    required ReplyOptions? option,
  }) {
    final reply = option == null
        ? null
        : Reply(
            memberId: memberId,
            scheduleId: scheduleId,
            instanceDate: instanceDate,
            selectedOption: option,
          );
    return _optimistically(
      read: () => _replies,
      write: (replies) => _replies = replies,
      key: _key(memberId, scheduleId, instanceDate),
      value: reply,
      save: () async {
        if (reply == null) {
          await _repliesService.deleteReply(
            memberId: memberId,
            scheduleId: scheduleId,
            instanceDate: instanceDate,
          );
          return null;
        }
        return _repliesService.createReply(reply);
      },
    );
  }

  /// Sets [memberId]'s default answer to the occurrences of [scheduleId]
  /// that [rule] matches, or removes it when [option] or [rule] is null.
  ///
  /// Shows up right away, and is undone if the server refuses it.
  Future<Result<void>> setDefaultRule({
    required String memberId,
    required String scheduleId,
    required RecurrenceRule? rule,
    required ReplyOptions? option,
  }) {
    final defaultRule = option == null || rule == null
        ? null
        : DefaultRule(
            memberId: memberId,
            scheduleId: scheduleId,
            selectedOption: option,
            recurrenceRule: rule,
          );
    return _optimistically(
      read: () => _defaultRules,
      write: (rules) => _defaultRules = rules,
      key: _key(memberId, scheduleId),
      value: defaultRule,
      save: () async {
        if (defaultRule == null) {
          await _defaultRulesService.deleteDefaultRule(
            memberId: memberId,
            scheduleId: scheduleId,
          );
          return null;
        }
        return _defaultRulesService.createDefaultRule(defaultRule);
      },
    );
  }

  /// Shows [value] under [key] (removing it if null) while [save] runs, then
  /// keeps what the server returned, or puts back what was there on failure.
  Future<Result<void>> _optimistically<T>({
    required Map<String, T> Function() read,
    required void Function(Map<String, T>) write,
    required String key,
    required T? value,
    required Future<T?> Function() save,
  }) async {
    final generation = this.generation;
    void show(T? value) => ifCurrent(generation, () {
      final entries = {...read()};
      value == null ? entries.remove(key) : entries[key] = value;
      write(entries);
    });

    final previous = read()[key];
    show(value);
    final result = await guard(save);
    switch (result) {
      case Ok(:final value):
        show(value);
        return const Result.ok(null);
      case Error(:final error):
        show(previous);
        return Result.error(error);
    }
  }

  static String _key(String memberId, String scheduleId, [DateTime? at]) =>
      // An instant identifies an occurrence, whatever its time zone label.
      '$memberId/$scheduleId/${at?.millisecondsSinceEpoch ?? ''}';

  static String _ruleKey(DefaultRule rule) =>
      _key(rule.memberId, rule.scheduleId);

  static String _replyKey(Reply reply) =>
      _key(reply.memberId, reply.scheduleId, reply.instanceDate);

  @override
  void clear() {
    _schedules = {};
    _defaultRules = {};
    _replies = {};
  }

  @override
  Map<String, dynamic> toCache() => {
    'schedules': [for (final schedule in _schedules.values) schedule.toJson()],
    'defaultRules': [for (final rule in _defaultRules.values) rule.toJson()],
    'replies': [for (final reply in _replies.values) reply.toJson()],
  };

  @override
  void fromCache(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(String key) =>
        (json[key] as List).cast<Map<String, dynamic>>();
    _schedules = {
      for (final schedule in rows('schedules').map(Schedule.fromJson))
        schedule.id: schedule,
    };
    _defaultRules = {
      for (final rule in rows('defaultRules').map(DefaultRule.fromJson))
        _ruleKey(rule): rule,
    };
    _replies = {
      for (final reply in rows('replies').map(Reply.fromJson))
        _replyKey(reply): reply,
    };
  }
}
