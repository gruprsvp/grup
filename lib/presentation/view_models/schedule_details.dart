import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// One occurrence of a schedule, with everyone's answer to it.
class ScheduleDetailsViewModel extends ChangeNotifier {
  ScheduleDetailsViewModel({
    required this.groupId,
    required this.scheduleId,
    required this.instanceDate,
    required this._groups,
    required this._schedules,
  }) {
    load = Command0(_load)..execute();
    _groups.addListener(_update);
    _schedules.addListener(_update);
    _update();
  }

  final String groupId;
  final String scheduleId;
  final DateTime instanceDate;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;

  ScheduleInstanceDetails? _details;

  /// Fetches the latest answers (and everything else, when opened from a
  /// link rather than from the group).
  late final Command0<void> load;

  Group? get group => _groups.group(groupId);

  /// `null` until loaded, or if the schedule has no such occurrence.
  ScheduleInstanceDetails? get details => _details;

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

  @override
  void dispose() {
    _groups.removeListener(_update);
    _schedules.removeListener(_update);
    super.dispose();
  }
}
