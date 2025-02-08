part of 'selectors.dart';

Iterable<Schedule> selectScheduleEntities(AppState state) =>
    state.schedules.entities.values;

final selectSchedulesIds =
    createSelector1(selectSchedules, (schedules) => schedules.map((s) => s.id));

ScheduleInstanceSummary repliesForScheduleInstance({
  required DateTime instanceDate,
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  required Iterable<Member> members,
  Iterable<DefaultRule>? defaultRules,
  Iterable<Reply>? replies,
  String? targetMemberId,
}) {
  final allReplies = <String, ReplyOptions>{};
  final memberReplies = <String, ReplyOptions>{};
  final memberDefaultReplies = <String, ReplyOptions>{};
  final memberDefaultRules = <String, DefaultRule>{};
  final membersSet = members.map((m) => m.id).toSet();

  ReplyOptions? myReply;
  ReplyOptions? myDefaultReply;
  DefaultRule? myDefaultRule;

  defaultRules?.forEach((defaultRule) {
    if (defaultRule.scheduleId == schedule.id) {
      if (defaultRule.memberId == targetMemberId) {
        myDefaultRule = defaultRule;
      } else {
        memberDefaultRules[defaultRule.memberId] = defaultRule;
      }
    }

    defaultRule.recurrenceRule
        .getInstances(
      start: schedule.startDate,
      after: startDate,
      before: endDate,
      includeAfter: true,
    )
        .forEach((e) {
      final isSameDay = e.copyWith(isUtc: true).isAtSameMomentAs(instanceDate);
      final isSameSchedule = defaultRule.scheduleId == schedule.id;

      if (isSameDay &&
          isSameSchedule &&
          membersSet.contains(defaultRule.memberId)) {
        if (defaultRule.memberId == targetMemberId) {
          myDefaultReply = defaultRule.selectedOption;
        } else {
          memberDefaultReplies[defaultRule.memberId] =
              defaultRule.selectedOption;
        }
        allReplies[defaultRule.memberId] = defaultRule.selectedOption;
      }
    });
  });

  replies?.forEach(
    (reply) {
      final isSameDay = reply.instanceDate
          .copyWith(isUtc: true)
          .isAtSameMomentAs(instanceDate);
      final isSameSchedule = reply.scheduleId == schedule.id;
      if (isSameDay && isSameSchedule && membersSet.contains(reply.memberId)) {
        if (reply.memberId == targetMemberId) {
          myReply = reply.selectedOption;
        } else {
          memberReplies[reply.memberId] = reply.selectedOption;
        }
        allReplies[reply.memberId] = reply.selectedOption;
      }
    },
  );

  final yesCount =
      allReplies.entries.where((e) => e.value == ReplyOptions.yes).length;

  return ScheduleInstanceSummary(
    scheduleId: schedule.id,
    groupId: schedule.groupId,
    displayName: schedule.displayName,
    instanceDate: instanceDate,
    memberReplies: memberReplies,
    memberDefaultReplies: memberDefaultReplies,
    memberDefaultRules: memberDefaultRules,
    yesCount: yesCount,
    myReply: myReply,
    myDefaultReply: myDefaultReply,
    myDefaultRule: myDefaultRule,
    targetMemberId: targetMemberId,
  );
}

Iterable<ScheduleInstanceSummary> getScheduleInstances({
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  required Iterable<Member> members,
  Iterable<DefaultRule>? defaultRules,
  Iterable<Reply>? replies,
  String? targetMemberId,
}) {
  final after =
      startDate.isAfter(schedule.startDate) ? startDate : schedule.startDate;
  return schedule.recurrenceRule
      .getInstances(
        start: schedule.startDate,
        after: after,
        before: endDate,
        includeAfter: true,
      )
      .map(
        (e) => repliesForScheduleInstance(
          instanceDate: e,
          schedule: schedule,
          defaultRules: defaultRules,
          replies: replies,
          startDate: after,
          endDate: endDate,
          members: members,
          targetMemberId: targetMemberId,
        ),
      );
}
