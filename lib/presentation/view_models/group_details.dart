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
    required this._billing,
    DateTime? date,
  }) : _date = date ?? DateTime.now(),
       // Opened without a date: show the next event rather than an empty
       // today. Most groups meet weekly, so today is usually empty.
       _findNext = date == null {
    load = Command0(_load)..execute();
    createSchedule = Command1(
      (schedule) => _schedules.create(schedule.copyWith(groupId: groupId)),
    );
    listenTo([_groups, _schedules], _update);
    listenTo([_billing, load, createSchedule]);
    _update();
  }

  final String groupId;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;
  final BillingRepository _billing;

  DateTime _date;
  bool _findNext;

  // Days worked out since the data last changed: the shown day, and the days
  // either side as a swipe brings them into view.
  final _instances = <DateTime, List<ScheduleInstanceSummary>>{};
  final _next = <DateTime, (Schedule, DateTime)?>{};

  /// Fetches the group, and its events around [date].
  late final Command0<void> load;

  /// Adds an event, for an admin setting the group up from this page.
  late final Command1<Schedule, Schedule> createSchedule;

  Group? get group => _groups.group(groupId);

  bool get isAdmin => _groups.ownMember(groupId)?.role == GroupRoles.admin;

  /// What the group's plan allows here.
  GroupAccess get access => _billing.access(groupId);

  /// When changes to [instance]'s answers closed, if they have: only admins
  /// answer then, and nobody clears an answer (reply_cutoffs).
  DateTime? closedAt(ScheduleInstanceSummary instance) {
    if (!access.can(FeatureKey.replyCutoffs)) return null;
    final closes = _schedules
        .schedule(instance.scheduleId)
        ?.closesAt(instance.instanceDate);
    return closes == null || DateTime.now().isBefore(closes) ? null : closes;
  }

  DateTime get date => _date;

  /// Whether anyone but the user is in the group, joined or invited.
  bool get hasOtherMembers => _groups.members(groupId).length > 1;

  /// Whether the group has any events at all, on any day.
  bool get hasSchedules => _schedules.schedules(groupId).isNotEmpty;

  /// The group's first event after [date], if any.
  (Schedule, DateTime)? get next => nextAfter(_date);

  /// The occurrences on [date], earliest first.
  List<ScheduleInstanceSummary> get instances => instancesOn(_date);

  /// The group's first event after [day], if any.
  (Schedule, DateTime)? nextAfter(DateTime day) => _next.putIfAbsent(
    day,
    () => nextOccurrence(_schedules.schedules(groupId), day.getDayEnd()),
  );

  /// The occurrences on [day], earliest first. Computed once per day while
  /// the data stays the same, not on every build.
  List<ScheduleInstanceSummary> instancesOn(DateTime day) => _instances
      .putIfAbsent(day, () => _instancesOn(day, _schedules.schedules(groupId)));

  void selectDate(DateTime date) {
    _findNext = false;
    _date = date;
    notifyListeners();
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
    // What the plan allows only adds to the page: it can't fail it.
    _billing.refresh().ignore();
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
  /// Two days either side: after a swipe, the day beyond shows before this
  /// load returns.
  Future<Result<void>> _loadSchedules() async {
    while (true) {
      final date = _date;
      final result = await _schedules.load(groupId, date.getNdayRange(2));
      if (date == _date) return result;
    }
  }

  void _update() {
    _instances.clear();
    _next.clear();
    final schedules = _schedules.schedules(groupId);
    if (_findNext && schedules.isNotEmpty) {
      _findNext = false;
      if (instances.isEmpty) {
        if (nextOccurrence(schedules, _date.getDayStart()) case (_, final at)) {
          // Occurrences carry the wall-clock time in UTC fields.
          _date = DateTime(at.year, at.month, at.day);
          // A running load picks the new date up when it finishes.
          load.execute();
        }
      }
    }
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
