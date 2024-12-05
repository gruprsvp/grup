import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

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
  final memberReplies = <int, ReplyOptions>{};
  final memberDefaultReplyOptions = <int, ReplyOptions>{};
  final memberDefaultReplies = <int, DefaultReply>{};

  ReplyOptions? myReply;
  ReplyOptions? myDefaultReplyOption;
  DefaultReply? myDefaultReply;

  defaultReplies?.forEach((defaultReply) {
    if (defaultReply.scheduleId == schedule.id) {
      if (defaultReply.memberId == targetMemberId) {
        myDefaultReply = defaultReply;
      } else {
        memberDefaultReplies[defaultReply.memberId] = defaultReply;
      }
    }

    defaultReply.recurrenceRule
        .getInstances(
      start: schedule.startDate,
      after: startDate,
      before: endDate,
      includeAfter: true,
    )
        .forEach((e) {
      final isSameDay = e.copyWith(isUtc: true).isAtSameMomentAs(instanceDate);
      final isSameSchedule = defaultReply.scheduleId == schedule.id;

      if (isSameDay && isSameSchedule) {
        if (defaultReply.memberId == targetMemberId) {
          myDefaultReplyOption = defaultReply.selectedOption;
        } else {
          memberDefaultReplyOptions[defaultReply.memberId] =
              defaultReply.selectedOption;
        }
        allReplies[defaultReply.memberId] = defaultReply.selectedOption;
      }
    });
  });

  replies?.forEach(
    (reply) {
      final isSameDay = reply.instanceDate
          .copyWith(isUtc: true)
          .isAtSameMomentAs(instanceDate);
      final isSameSchedule = reply.scheduleId == schedule.id;
      if (isSameDay && isSameSchedule) {
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
    memberDefaultReplyOptions: memberDefaultReplyOptions,
    memberDefaultReplies: memberDefaultReplies,
    yesCount: yesCount,
    myReply: myReply,
    myDefaultReplyOption: myDefaultReplyOption,
    myDefaultReply: myDefaultReply,
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
