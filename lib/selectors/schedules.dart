import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:rrule/rrule.dart';

ScheduleInstanceSummary repliesForScheduleInstance({
  required DateTime instanceDate,
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
  Iterable<DefaultRule>? defaultRules,
  Iterable<Reply>? replies,
  String? targetMemberId,
}) {
  final allReplies = <String, Reply>{};
  final memberReplies = <String, Reply>{};
  final memberDefaultReplies = <String, Reply>{};
  final memberDefaultRules = <String, DefaultRule>{};

  Reply? myReply;
  Reply? myDefaultReply;
  DefaultRule? myDefaultRule;

  defaultRules?.forEach((defaultRule) {
    if (defaultRule.schedule.id == schedule.id) {
      if (defaultRule.member.id == targetMemberId) {
        myDefaultRule = defaultRule;
      } else {
        memberDefaultRules[defaultRule.member.id] = defaultRule;
      }
    }

    defaultRule.recurrenceRule
        .getInstances(
      start: schedule.startDate,
      after: startDate,
      before: endDate,
      includeAfter: true,
    )
        .forEach((dateTime) {
      final isSameDay =
          dateTime.copyWith(isUtc: true).isAtSameMomentAs(instanceDate);
      final isSameSchedule = defaultRule.schedule.id == schedule.id;

      if (isSameDay && isSameSchedule) {
        final defaultReply = Reply(
          instanceDate: dateTime,
          schedule: schedule,
          member: defaultRule.member,
          selectedOption: defaultRule.selectedOption,
        );
        if (defaultRule.member.id == targetMemberId) {
          myDefaultReply = defaultReply;
        } else {
          memberDefaultReplies[defaultRule.member.id] = defaultReply;
        }
        allReplies[defaultRule.member.id] = defaultReply;
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
          myReply = reply;
        } else {
          memberReplies[reply.member.id] = reply;
        }
        allReplies[reply.member.id] = reply;
      }
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
    targetMemberId: targetMemberId,
  );
}

Iterable<ScheduleInstanceSummary> getScheduleInstances({
  required Schedule schedule,
  required DateTime startDate,
  required DateTime endDate,
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
          targetMemberId: targetMemberId,
        ),
      );
}
