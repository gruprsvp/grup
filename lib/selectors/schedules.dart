import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
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
    if (defaultReply.schedule.id == schedule.id) {
      if (defaultReply.member.id == targetMemberId) {
        myDefaultReply = defaultReply;
      } else {
        memberDefaultReplies[defaultReply.member.id] = defaultReply;
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
      final isSameSchedule = defaultReply.schedule.id == schedule.id;

      if (isSameDay && isSameSchedule) {
        if (defaultReply.member.id == targetMemberId) {
          myDefaultReplyOption = defaultReply.selectedOption;
        } else {
          memberDefaultReplyOptions[defaultReply.member.id] =
              defaultReply.selectedOption;
        }
        allReplies[defaultReply.member.id] = defaultReply.selectedOption;
      }
    });
  });

  replies?.forEach(
    (reply) {
      final isSameDay = reply.instanceDate
          .copyWith(isUtc: true)
          .isAtSameMomentAs(instanceDate);
      final isSameSchedule = reply.schedule.id == schedule.id;
      if (isSameDay && isSameSchedule) {
        if (reply.member.id == targetMemberId) {
          myReply = reply.selectedOption;
        } else {
          memberReplies[reply.member.id] = reply.selectedOption;
        }
        allReplies[reply.member.id] = reply.selectedOption;
      }
    },
  );

  final yesCount =
      allReplies.entries.where((e) => e.value == ReplyOptions.yes).length;

  return ScheduleInstanceSummary(
    scheduleId: schedule.id,
    groupId: schedule.group.id,
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
