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
  final allDefaultOptions = <int, RecurrenceRule>{};

  defaultReplies?.forEach((defaultReply) {
    allDefaultOptions[defaultReply.memberId] = defaultReply.recurrenceRule;

    defaultReply.recurrenceRule
        .getInstances(
          start: schedule.startDate,
          after: startDate,
          before: endDate,
          includeAfter: true,
        )
        .forEach((e) => e
                    .copyWith(isUtc: true)
                    .isAtSameMomentAs(instanceDate) &&
                defaultReply.scheduleId == schedule.id
            ? allReplies[defaultReply.memberId] = defaultReply.selectedOption
            : null);
  });

  replies?.forEach(
    (reply) => reply.instanceDate
                .copyWith(isUtc: true)
                .isAtSameMomentAs(instanceDate) &&
            reply.scheduleId == schedule.id
        ? allReplies[reply.memberId] = reply.selectedOption
        : null,
  );

  final myReply = allReplies[targetMemberId];
  final myDefaultOption = allDefaultOptions[targetMemberId];
  final yesCount = allReplies.values.where((e) => e == ReplyOptions.yes).length;

  return ScheduleInstanceSummary(
    scheduleId: schedule.id,
    groupId: schedule.groupId,
    displayName: schedule.displayName,
    instanceDate: instanceDate,
    memberReplies: allReplies,
    memberDefaultOptions: allDefaultOptions,
    yesCount: yesCount,
    myReply: myReply,
    myDefaultOption: myDefaultOption,
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

List<(Member, ReplyOptions?)> getMemberReplies({
  required int? targetMemberId,
  required Iterable<Member> members,
  required Map<int, ReplyOptions> replies,
  required Map<String, Profile> profiles,
}) {
  return members
      .map(
        (m) {
          final reply = replies[m.id];
          return (
            m.copyWith(
                displayNameOverride: m.displayNameOverride ??
                    profiles[m.profileId]?.displayName),
            reply
          );
        },
      )
      .where((e) => e.$1.id != targetMemberId)
      .toList();
}

List<RecurrenceRule?> getMemberDefaultOptions({
  required int? targetMemberId,
  required Iterable<Member> members,
  required Map<int, RecurrenceRule> defaultOptions,
  required Map<String, Profile> profiles,
}) {
  return members
      .where((m) => m.id != targetMemberId)
      .map((m) => defaultOptions[m.id])
      .toList();
}
