import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import 'view_model.dart';

/// A group's next occurrence. [counted] is false when it's too far ahead
/// for its answers to have been loaded.
typedef NextEvent = ({ScheduleInstanceSummary event, bool counted});

/// The home screen: the user's groups, each with its next event.
class HomeViewModel extends ViewModel {
  HomeViewModel({
    required this._groups,
    required this._profile,
    required this._settings,
    required this._schedules,
  }) {
    refresh = Command0(_refresh)..execute();
    create = Command1((args) => _groups.create(args.group, image: args.image));
    join = Command1(_groups.join);
    listenTo([_groups, _schedules], () {
      _next.clear();
      notifyListeners();
    });
    listenTo([_profile, _settings, refresh, create, join]);
  }

  /// How far ahead answers are loaded: a next event later than this shows
  /// without a count, rather than one that ignores everyone's answers.
  static const lookahead = 31;

  final GroupsRepository _groups;
  final ProfileRepository _profile;
  final SettingsRepository _settings;
  final SchedulesRepository _schedules;

  /// Worked out once per group while the data stays the same.
  final _next = <String, NextEvent?>{};

  late final Command0<void> refresh;
  late final Command1<Group, ({Group group, XFile? image})> create;
  late final Command1<void, String> join;

  List<Group> get groups => _groups.groups;

  Profile? get profile => _profile.profile;

  /// The profile has loaded, and the user hasn't told us their name yet.
  bool get needsName =>
      profile != null && (profile!.displayName?.trim().isEmpty ?? true);

  /// Ask for feedback once the user has been around for a few days.
  bool get showFeedbackCard =>
      !_settings.feedbackDismissed &&
      (profile?.createdAt?.isBefore(
            DateTime.now().subtract(const Duration(days: 3)),
          ) ??
          false);

  void dismissFeedback() => _settings.dismissFeedback();

  /// Ask once whether the user shares usage analytics.
  bool get showAnalyticsCard => _settings.analytics == null;

  void setAnalytics(bool enabled) => _settings.setAnalytics(enabled);

  /// [groupId]'s next occurrence that hasn't started yet, with who's coming.
  NextEvent? nextEvent(String groupId) =>
      _next.putIfAbsent(groupId, () => _nextEvent(groupId));

  NextEvent? _nextEvent(String groupId) {
    final now = DateTime.now();
    // Occurrences carry the wall-clock time in UTC fields: so does "now", so
    // an event that already started today isn't "next".
    final from = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    final next = nextOccurrence(_schedules.schedules(groupId), from);
    if (next == null) return null;
    final (schedule, at) = next;
    final day = DateTime(at.year, at.month, at.day).getDayRange();
    final event = getScheduleInstances(
      schedule: schedule,
      startDate: day.start,
      endDate: day.end,
      members: _groups.members(groupId),
      defaultRules: _schedules.defaultRules(groupId),
      replies: _schedules.replies(groupId),
      targetMemberId: _groups.ownMember(groupId)?.id,
    ).firstWhereOrNull((e) => e.instanceDate.isAtSameMomentAs(at));
    if (event == null) return null;
    final counted = day.start.isBefore(_window(now.getDayStart()).end);
    return (event: event, counted: counted);
  }

  static DateTimeRange _window(DateTime today) => DateTimeRange(
    start: today,
    end: today.add(const Duration(days: lookahead)).getDayEnd(),
  );

  Future<Result<void>> _refresh() async {
    final results = await Future.wait([_groups.refresh(), _profile.load()]);
    // Each group's events, for its next one. Their failures don't fail the
    // page: the groups are what it's for, and each event falls back to cache.
    final window = _window(DateTime.now().getDayStart());
    await Future.wait([
      for (final group in groups) _schedules.load(group.id, window),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }
}
