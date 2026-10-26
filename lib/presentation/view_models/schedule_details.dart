import 'package:collection/collection.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

import 'view_model.dart';

/// One occurrence of a schedule, with everyone's answer to it.
class ScheduleDetailsViewModel extends ViewModel {
  ScheduleDetailsViewModel({
    required this.groupId,
    required this.scheduleId,
    required this.instanceDate,
    required this._groups,
    required this._schedules,
    required this._billing,
  }) {
    load = Command0(_load)..execute();
    listenTo([_groups, _schedules, _billing], _update);
    listenTo([load]);
    _update();
  }

  final String groupId;
  final String scheduleId;
  final DateTime instanceDate;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;
  final BillingRepository _billing;

  ScheduleInstanceDetails? _details;
  Set<String> _late = const {};

  /// Fetches the latest answers (and everything else, when opened from a
  /// link rather than from the group).
  late final Command0<void> load;

  Group? get group => _groups.group(groupId);

  /// `null` until loaded, or if the schedule has no such occurrence.
  ScheduleInstanceDetails? get details => _details;

  /// When changes to the answers closed, if they have: only admins answer
  /// then, and nobody clears an answer (reply_cutoffs).
  DateTime? get closedAt {
    if (!_billing.access(groupId).can(FeatureKey.replyCutoffs)) return null;
    final closes = _schedules.schedule(scheduleId)?.closesAt(instanceDate);
    return closes == null || DateTime.now().isBefore(closes) ? null : closes;
  }

  /// The members who changed their answer after changes closed, for admins.
  Set<String> get lateMembers => _late;

  /// How the event recurs; `null` until loaded.
  RecurrenceRule? get scheduleRule =>
      _schedules.schedule(scheduleId)?.recurrenceRule;

  /// Answers for [memberId] (the user, or anyone when the user is an admin),
  /// or clears the answer when [option] is null.
  Future<Result<void>> reply(String memberId, ReplyOptions? option) =>
      _schedules.reply(
        memberId: memberId,
        scheduleId: scheduleId,
        instanceDate: instanceDate,
        option: option,
      );

  /// Sets [memberId]'s default answer for the occurrences [rule] matches.
  Future<Result<void>> setDefaultRule(
    String memberId,
    RecurrenceRule? rule,
    ReplyOptions? option,
  ) => _schedules.setDefaultRule(
    memberId: memberId,
    scheduleId: scheduleId,
    rule: rule,
    option: option,
  );

  Future<Result<void>> _load() async {
    // What the plan allows only adds to the page: it can't fail it.
    _billing.refresh().ignore();
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _schedules.load(groupId, instanceDate.getNdayRange(1)),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  void _update() {
    final schedule = _schedules.schedule(scheduleId);
    final members = _groups.members(groupId);
    final range = instanceDate.getDayRange();
    // Resolved exactly as in the group's list, so the counts agree.
    final summary = schedule == null
        ? null
        : getScheduleInstances(
            schedule: schedule,
            startDate: range.start,
            endDate: range.end,
            members: members,
            defaultRules: _schedules.defaultRules(groupId),
            replies: _schedules.replies(groupId),
            targetMemberId: _groups.ownMember(groupId)?.id,
          ).firstWhereOrNull(
            (instance) => instance.instanceDate.isAtSameMomentAs(instanceDate),
          );
    final isAdmin = _groups.ownMember(groupId)?.role == GroupRoles.admin;
    _late =
        summary == null ||
            schedule == null ||
            !isAdmin ||
            !_billing.access(groupId).can(FeatureKey.replyCutoffs)
        ? const {}
        : lateMemberIds(schedule, summary, _schedules.replies(groupId));
    _details = summary == null
        ? null
        : scheduleInstanceDetails(
            summary,
            [
              for (final member in members)
                (member, _groups.profile(member.profileId)),
            ],
            canEditOthers: _groups.ownMember(groupId)?.role == GroupRoles.admin,
          );
    notifyListeners();
  }
}
