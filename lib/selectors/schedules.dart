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
    if (defaultRule.scheduleId != schedule.id) return;

    if (defaultRule.memberId == targetMemberId) {
      myDefaultRule = defaultRule;
    } else {
      memberDefaultRules[defaultRule.memberId] = defaultRule;
    }

    defaultRule.recurrenceRule
        .getInstances(
      start: start,
      after: after,
      before: before,
      includeAfter: true,
    )
        .forEach((dateTime) {
      final defaultReplyDate = dateTime.copyWith(isUtc: false);
      final isSameDay = defaultReplyDate.isAtSameMomentAs(instanceDate);
      final memberExists = membersSet.contains(defaultRule.memberId);

      if (!isSameDay || !memberExists) return;

      final defaultReply = defaultRule.selectedOption;

      if (defaultRule.memberId == targetMemberId) {
        myDefaultReply = defaultReply;
      } else {
        memberDefaultReplies[defaultRule.memberId] = defaultReply;
      }
      allReplies[defaultRule.memberId] = defaultReply;
    });
  });

  replies?.forEach(
    (reply) {
      if (reply.scheduleId != schedule.id) return;

      final isSameDay = reply.instanceDate
          .copyWith(isUtc: false)
          .isAtSameMomentAs(instanceDate);
      final memberExists = membersSet.contains(reply.memberId);

      if (!isSameDay || !memberExists) return;

      final replyOption = reply.selectedOption;
      if (reply.memberId == targetMemberId) {
        myReply = replyOption;
      } else {
        memberReplies[reply.memberId] = replyOption;
      }
      allReplies[reply.memberId] = replyOption;
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
    timezone: schedule.timezone,
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
          targetMemberId: targetMemberId,
        ),
      );
}
