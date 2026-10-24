import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import 'view_model.dart';

/// A group's events on one day, with everyone's answers.
class GroupDetailsViewModel extends ViewModel {
  GroupDetailsViewModel({
    required this.groupId,
    required this._groups,
    required this._schedules,
    DateTime? date,
  }) : _date = date ?? DateTime.now(),
       // Opened without a date: show the next event rather than an empty
       // today. Most groups meet weekly, so today is usually empty.
       _findNext = date == null {
    load = Command0(_load)..execute();
    listenTo([_groups, _schedules], _update);
    listenTo([load]);
    _update();
  }

  final String groupId;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;

  DateTime _date;
  bool _findNext;
  List<ScheduleInstanceSummary> _instances = const [];
  (Schedule, DateTime)? _next;

  /// Fetches the group, and its events around [date].
  late final Command0<void> load;

  Group? get group => _groups.group(groupId);

  bool get isAdmin => _groups.ownMember(groupId)?.role == GroupRoles.admin;

  DateTime get date => _date;

  /// Whether the group has any events at all, on any day.
  bool get hasSchedules => _schedules.schedules(groupId).isNotEmpty;

  /// The group's first event after [date], if any.
  (Schedule, DateTime)? get next => _next;

  /// The occurrences on [date], earliest first. Computed when the data or the
  /// date changes, not on every build.
  List<ScheduleInstanceSummary> get instances => _instances;

  void selectDate(DateTime date) {
    _findNext = false;
    _date = date;
    _update();
    // A running load picks the new date up when it finishes (see _load).
    load.execute();
  }

  /// Answers [instance] for the user, or clears their answer when [option]
  /// is null.
  ///
  /// Not a [Command]: a command ignores a second tap while the first is
  /// running, and the user may answer several events in quick succession.
  /// The answer shows at once; the result says whether it was saved.
  Future<Result<void>> reply(
    ScheduleInstanceSummary instance,
    ReplyOptions? option,
  ) {
    final memberId = instance.targetMemberId;
    if (memberId == null) {
      return Future.value(const Result.error(NotAllowedException()));
    }
    return _schedules.reply(
      memberId: memberId,
      scheduleId: instance.scheduleId,
      instanceDate: instance.instanceDate,
      option: option,
    );
  }

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _loadSchedules(),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  /// Loads the replies around [date], again if the date changed meanwhile.
  Future<Result<void>> _loadSchedules() async {
    while (true) {
      final date = _date;
      final result = await _schedules.load(groupId, date.getNdayRange(1));
      if (date == _date) return result;
    }
  }

  void _update() {
    final schedules = _schedules.schedules(groupId);
    _instances = _instancesOn(_date, schedules);
    if (_findNext && schedules.isNotEmpty) {
      _findNext = false;
      if (_instances.isEmpty) {
        if (nextOccurrence(schedules, _date.getDayStart()) case (_, final at)) {
          // Occurrences carry the wall-clock time in UTC fields.
          _date = DateTime(at.year, at.month, at.day);
          _instances = _instancesOn(_date, schedules);
          // A running load picks the new date up when it finishes.
          load.execute();
        }
      }
    }
    _next = nextOccurrence(schedules, _date.getDayEnd());
    notifyListeners();
  }

  List<ScheduleInstanceSummary> _instancesOn(
    DateTime date,
    List<Schedule> schedules,
  ) {
    final range = date.getDayRange();
    final members = _groups.members(groupId);
    final targetMemberId = _groups.ownMember(groupId)?.id;
    final defaultRules = _schedules.defaultRules(groupId);
    final replies = _schedules.replies(groupId);
    return [
      for (final schedule in schedules)
        // Schedules that start later have no occurrence on this day.
        if (!schedule.startDate.isAfter(range.end))
          ...getScheduleInstances(
            schedule: schedule,
            startDate: range.start,
            endDate: range.end,
            members: members,
            defaultRules: defaultRules,
            replies: replies,
            targetMemberId: targetMemberId,
          ),
    ]..sort((a, b) => a.instanceDate.compareTo(b.instanceDate));
  }
}
