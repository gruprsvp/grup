import 'package:parousia/models/models.dart';

ScheduleInstance repliesForScheduleInstance({
  required DateTime eventDate,
  required Schedule schedule,
  required Iterable<DefaultReply> defaultReplies,
  required Iterable<Reply> replies,
  required DateTime startDate,
  required DateTime endDate,
  int? targetUserId,
}) {
  return ScheduleInstance(
    scheduleId: schedule.id,
    displayName: schedule.displayName,
    eventDate: eventDate,
    // TODO
    yesCount: 0,
    myReply: ReplyOptions.yes,
  );
}

Iterable<ScheduleInstance> getScheduleInstances({
  required Schedule schedule,
  required Iterable<DefaultReply> defaultReplies,
  required Iterable<Reply> replies,
  required DateTime startDate,
  required DateTime endDate,
  int? targetUserId,
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
            targetUserId: targetUserId,
          ),
        );
