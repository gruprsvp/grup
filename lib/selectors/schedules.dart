part of 'selectors.dart';

Iterable<Schedule> selectScheduleEntities(AppState state) =>
    state.schedules.entities.values;

final selectSchedulesIds =
    createSelector1(selectSchedules, (schedules) => schedules.map((s) => s.id));

ScheduleInstanceSummary repliesForScheduleInstance({
  required DateTime instanceDate,
  required Schedule schedule,
  required DateTime start,
  required DateTime after,
  required DateTime before,
  required Iterable<Member> members,
  Iterable<DefaultRule>? defaultRules,
  Iterable<Reply>? replies,
  Member? targetMember,
}) {
  final allReplies = <String, Reply>{};
  final memberReplies = <String, Reply>{};
  final memberDefaultReplies = <String, Reply>{};
  final memberDefaultRules = <String, DefaultRule>{};
  final membersSet = members.map((m) => m.id).toSet();

  Reply? myReply;
  Reply? myDefaultReply;
  DefaultRule? myDefaultRule;

  defaultRules?.forEach((defaultRule) {
    if (defaultRule.schedule.id != schedule.id) return;

    if (defaultRule.member.id == targetMember?.id) {
      myDefaultRule = defaultRule;
    } else {
      memberDefaultRules[defaultRule.member.id] = defaultRule;
    }

    defaultRule.recurrenceRule
        ?.getInstances(
      start: start,
      after: after,
      before: before,
      includeAfter: true,
    )
        .forEach((dateTime) {
      final defaultReplyDate = dateTime.copyWith(isUtc: false);
      final isSameDay = defaultReplyDate.isAtSameMomentAs(instanceDate);
      final memberExists = membersSet.contains(defaultRule.member.id);

      if (!isSameDay || !memberExists) return;

      final defaultReply = Reply(
        instanceDate: instanceDate,
        schedule: schedule,
        member: defaultRule.member,
        selectedOption: defaultRule.selectedOption,
      );
      if (defaultRule.member.id == targetMember?.id) {
        myDefaultReply = defaultReply;
      } else {
        memberDefaultReplies[defaultRule.member.id] = defaultReply;
      }
      allReplies[defaultRule.member.id] = defaultReply;
    });
  });

  replies?.forEach(
    (reply) {
      if (reply.schedule.id != schedule.id) return;

      final isSameDay = reply.instanceDate
          .copyWith(isUtc: false)
          .isAtSameMomentAs(instanceDate);
      final memberExists = membersSet.contains(reply.member.id);

      if (!isSameDay || !memberExists) return;

      if (reply.member.id == targetMember?.id) {
        myReply = reply;
      } else {
        memberReplies[reply.member.id] = reply;
      }
      allReplies[reply.member.id] = reply;
    },
  );

  final yesCount = allReplies.entries
      .where((e) => e.value.selectedOption == ReplyOptions.yes)
      .length;

  return ScheduleInstanceSummary(
    schedule: schedule,
    groupId: schedule.group.id,
    displayName: schedule.displayName,
    instanceDate: instanceDate,
    memberReplies: memberReplies,
    memberDefaultReplies: memberDefaultReplies,
    memberDefaultRules: memberDefaultRules,
    yesCount: yesCount,
    myReply: myReply,
    myDefaultReply: myDefaultReply,
    myDefaultRule: myDefaultRule,
    targetMember: targetMember,
  );
}

Iterable<ScheduleInstanceSummary> getScheduleInstances({
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  required Iterable<Member> members,
  Iterable<DefaultRule>? defaultRules,
  Iterable<Reply>? replies,
  Member? targetMember,
}) {
  final start = schedule.startDate.copyWith(isUtc: true);
  final after =
      startDate.isAfter(start) ? startDate.copyWith(isUtc: true) : start;
  final before = endDate.copyWith(isUtc: true);
  return schedule.recurrenceRule
      .getInstances(
        start: start,
        after: after,
        before: before,
        includeAfter: true,
      )
      .map(
        (instanceDate) => repliesForScheduleInstance(
          instanceDate: instanceDate.copyWith(isUtc: false),
          schedule: schedule,
          defaultRules: defaultRules,
          replies: replies,
          start: start,
          after: after,
          before: before,
          members: members,
          targetMember: targetMember,
        ),
      );
}
