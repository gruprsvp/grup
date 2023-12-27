import 'package:parousia/models/models.dart';

ScheduleInstance repliesForScheduleInstance({
  required DateTime eventDate,
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
        .forEach((e) => e.copyWith(isUtc: true).isAtSameMomentAs(eventDate)
            ? allReplies[defaultReply.memberId] = defaultReply.selectedOption
            : null),
  );

  replies?.forEach(
    (reply) => reply.eventDate.copyWith(isUtc: true).isAtSameMomentAs(eventDate)
        ? allReplies[reply.memberId] = reply.selectedOption
        : null,
  );

  final myReply = allReplies[targetMemberId];
  final yesCount = allReplies.values.where((e) => e == ReplyOptions.yes).length;

  return ScheduleInstance(
    scheduleId: schedule.id,
    displayName: schedule.displayName,
    eventDate: eventDate,
    yesCount: yesCount,
    myReply: myReply,
    targetMemberId: targetMemberId,
  );
}

Iterable<ScheduleInstance> getScheduleInstances({
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  Iterable<DefaultReply>? defaultReplies,
  Iterable<Reply>? replies,
  int? targetMemberId,
}) =>
    schedule.recurrenceRule
        .getInstances(
          start: schedule.startDate,
          after: startDate,
          before: endDate,
          includeAfter: true,
        )
        .map(
          (e) => repliesForScheduleInstance(
            eventDate: e,
            schedule: schedule,
            defaultReplies: defaultReplies,
            replies: replies,
            startDate: startDate,
            endDate: endDate,
            targetMemberId: targetMemberId,
          ),
        );
