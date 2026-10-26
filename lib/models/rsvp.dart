import 'package:collection/collection.dart';
import 'package:rrule/rrule.dart';

import 'enum.dart';
import 'member.dart';
import 'profile.dart';
import 'reply.dart';
import 'default_reply.dart';
import 'schedule.dart';
import 'schedule_summary.dart';

// RSVP resolution: who answered what for each occurrence of a schedule,
// combining replies with the default rules that answer in advance.
// test/schedules_characterization_test.dart pins this behaviour.

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
          final isSameDay = e
              .copyWith(isUtc: true)
              .isAtSameMomentAs(instanceDate);
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

  replies?.forEach((reply) {
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
  });

  final yesCount = allReplies.entries
      .where((e) => e.value == ReplyOptions.yes)
      .length;

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
  final after = startDate.isAfter(schedule.startDate)
      ? startDate
      : schedule.startDate;
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

/// Groups the members by their answer to [instance], for the detail view.
/// The user (the instance's target member) is counted but not listed.
ScheduleInstanceDetails scheduleInstanceDetails(
  ScheduleInstanceSummary instance,
  Iterable<(Member, Profile?)> members, {
  required bool canEditOthers,
}) {
  final groupedMembers = members
      .map(
        (m) => ScheduleInstanceMember(
          member: m.$1,
          reply: instance.memberReplies[m.$1.id],
          defaultReply: instance.memberDefaultReplies[m.$1.id],
          defaultRule: instance.memberDefaultRules[m.$1.id],
          profile: m.$2,
        ),
      )
      .whereNot((m) => m.member.id == instance.targetMemberId)
      .groupListsBy((m) => m.reply ?? m.defaultReply);

  // The user is counted in the group of their answer, but not listed there:
  // the detail view shows them on their own, above the groups.
  final ownReply = instance.myReply ?? instance.myDefaultReply;
  final repliesGroups = [
    for (final reply in const [ReplyOptions.yes, ReplyOptions.no, null])
      if (groupedMembers.containsKey(reply) || ownReply == reply)
        ScheduleInstanceRepliesGroup(
          reply: reply,
          count:
              (groupedMembers[reply]?.length ?? 0) +
              (ownReply == reply ? 1 : 0),
          members: groupedMembers[reply] ?? const [],
        ),
  ];

  return ScheduleInstanceDetails(
    scheduleId: instance.scheduleId,
    groupId: instance.groupId,
    displayName: instance.displayName,
    instanceDate: instance.instanceDate,
    repliesGroups: repliesGroups,
    myReply: instance.myReply,
    myDefaultReply: instance.myDefaultReply,
    myDefaultRule: instance.myDefaultRule,
    targetMemberId: instance.targetMemberId,
    canEditOthers: canEditOthers,
  );
}

/// The headcount for an occurrence, split by how sure it is.
extension Headcount on ScheduleInstanceSummary {
  /// Who answered yes, the user included.
  int get confirmedYes =>
      memberReplies.values.where((r) => r == ReplyOptions.yes).length +
      (myReply == ReplyOptions.yes ? 1 : 0);

  /// Who is counted as coming only by their usual answer: they haven't
  /// answered this occurrence. [confirmedYes] + [usualYes] == `yesCount`.
  int get usualYes =>
      memberDefaultReplies.entries
          .where(
            (e) =>
                e.value == ReplyOptions.yes &&
                !memberReplies.containsKey(e.key),
          )
          .length +
      (myReply == null && myDefaultReply == ReplyOptions.yes ? 1 : 0);
}

/// The earliest occurrence of any of [schedules] from [from] on, looking no
/// further than [horizon] ahead; `null` if there is none.
(Schedule, DateTime)? nextOccurrence(
  Iterable<Schedule> schedules,
  DateTime from, {
  Duration horizon = const Duration(days: 366),
}) {
  (Schedule, DateTime)? next;
  for (final schedule in schedules) {
    final after = from.isAfter(schedule.startDate) ? from : schedule.startDate;
    // Open-ended rules recur forever: take the first, never the whole list.
    final first = schedule.recurrenceRule
        .getInstances(
          start: schedule.startDate,
          after: after,
          before: from.add(horizon),
          includeAfter: true,
        )
        .firstOrNull;
    if (first != null && (next == null || first.isBefore(next.$2))) {
      next = (schedule, first);
    }
  }
  return next;
}

/// The headcount for an occurrence's details, as [Headcount] for summaries.
extension DetailsHeadcount on ScheduleInstanceDetails {
  /// How many are in the [reply] group (`null`: no reply yet).
  int count(ReplyOptions? reply) =>
      repliesGroups.firstWhereOrNull((g) => g.reply == reply)?.count ?? 0;

  /// Who answered yes, the user included.
  int get confirmedYes =>
      (repliesGroups
              .firstWhereOrNull((g) => g.reply == ReplyOptions.yes)
              ?.members
              .where((m) => m.reply == ReplyOptions.yes)
              .length ??
          0) +
      (myReply == ReplyOptions.yes ? 1 : 0);

  /// Who is counted as coming only by their usual answer.
  int get usualYes => count(ReplyOptions.yes) - confirmedYes;
}

/// Who changed their answer to [instance] late: after changes closed and
/// before it started (reply_cutoffs). An answer is a reply, or the usual
/// answer it falls back to. The instance's own target member isn't
/// considered: resolve it without one to cover everyone.
Set<String> lateMemberIds(
  Schedule schedule,
  ScheduleInstanceSummary instance,
  Iterable<Reply> replies,
) {
  final closes = schedule.closesAt(instance.instanceDate);
  if (closes == null) return const {};
  final starts = schedule.startsAt(instance.instanceDate);
  bool late(DateTime? at) =>
      at != null && !at.isBefore(closes) && at.isBefore(starts);
  return {
    for (final reply in replies)
      if (reply.scheduleId == schedule.id &&
          reply.memberId != instance.targetMemberId &&
          reply.instanceDate
              .copyWith(isUtc: true)
              .isAtSameMomentAs(instance.instanceDate) &&
          late(reply.updatedAt))
        reply.memberId,
    for (final memberId in instance.memberDefaultReplies.keys)
      if (!instance.memberReplies.containsKey(memberId) &&
          late(instance.memberDefaultRules[memberId]?.updatedAt))
        memberId,
  };
}
