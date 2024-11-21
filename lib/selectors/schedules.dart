import 'package:parousia/models/models.dart';

ScheduleInstanceSummary repliesForScheduleInstance({
  required DateTime instanceDate,
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  Iterable<DefaultReply>? defaultReplies,
  Iterable<Reply>? replies,
  int? targetMemberId,
}) {
  final allReplies = <int, ReplyOptions>{};

  defaultReplies?.forEach(
    (defaultReply) => defaultReply.recurrenceRule
        .getInstances(
          start: schedule.startDate,
          after: startDate,
          before: endDate,
          includeAfter: true,
        )
        .forEach((e) => e.copyWith(isUtc: true).isAtSameMomentAs(instanceDate)
            ? allReplies[defaultReply.memberId] = defaultReply.selectedOption
            : null),
  );

  replies?.forEach(
    (reply) => reply.instanceDate
                .copyWith(isUtc: true)
                .isAtSameMomentAs(instanceDate) &&
            reply.scheduleId == schedule.id
        ? allReplies[reply.memberId] = reply.selectedOption
        : null,
  );

  final myReply = allReplies[targetMemberId];
  final yesCount = allReplies.values.where((e) => e == ReplyOptions.yes).length;

  return ScheduleInstanceSummary(
    scheduleId: schedule.id,
    groupId: schedule.groupId,
    displayName: schedule.displayName,
    instanceDate: instanceDate,
    memberReplies: allReplies,
    yesCount: yesCount,
    myReply: myReply,
    targetMemberId: targetMemberId,
  );
}

Iterable<ScheduleInstanceSummary> getScheduleInstances({
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  Iterable<DefaultReply>? defaultReplies,
  Iterable<Reply>? replies,
  int? targetMemberId,
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
          defaultReplies: defaultReplies,
          replies: replies,
          startDate: after,
          endDate: endDate,
          targetMemberId: targetMemberId,
        ),
      );
}
