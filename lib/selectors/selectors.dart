import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:memoized/memoized.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:reselect/reselect.dart';
import 'package:rrule/rrule.dart';
import 'package:supabase/supabase.dart';

part 'auth.dart';
part 'default_rules.dart';
part 'feedback.dart';
part 'groups.dart';
part 'locale.dart';
part 'members.dart';
part 'profiles.dart';
part 'replies.dart';
part 'schedules.dart';
part 'selected_date.dart';
part 'theme.dart';

// TODO Where to group these view model selectors?

final selectSchedules = createSelector3(
    selectScheduleEntities,
    selectGroupId,
    selectedDateRangeSelector,
    (schedules, groupId, range) => schedules.where((s) =>
        s.groupId.toString() == groupId &&
        (s.startDate.isBefore(range.start) ||
            (s.startDate.compareTo(range.start) >= 0 &&
                s.startDate.compareTo(range.end) <= 0))));

final selectDefaultRules = createSelector2(
    selectAllDefaultRules,
    selectSchedulesIds,
    (replies, scheduleIds) =>
        replies.where((r) => scheduleIds.contains(r.scheduleId)));

final selectReplies = createSelector3(
    selectAllReplies,
    selectSchedulesIds,
    selectedDateRangeSelector,
    (replies, scheduleIds, range) => replies.where((r) =>
        scheduleIds.contains(r.scheduleId) && range.contains(r.instanceDate)));

// TODO This selector and selectScheduleInstanceForDate are very similar,
// however, this one is used in the list view and the other in the detail view.
// This one is simpler because it doesn't need to group the members by their reply,
// however, by doing so, there is a mismatch as some replies may still be counted,
// even if a member is no longer part of the group.
final selectScheduleInstancesForSelectedDate = createSelector6(
    selectedDateRangeSelector,
    selectMyMember,
    selectSchedules,
    selectDefaultRules,
    selectReplies,
    groupMembersSelector,
    (range, myMember, schedules, defaultRules, replies, members) =>
        schedules.expand((schedule) => getScheduleInstances(
              schedule: schedule,
              defaultRules: defaultRules,
              startDate: range.start,
              endDate: range.end,
              replies: replies,
              members: members,
              targetMemberId: myMember?.$1.id,
            )));

String? selectScheduleId(AppState state) => state.selectedScheduleId;

final selectScheduleInstanceSummary = createSelector2(
    selectScheduleInstancesForSelectedDate,
    selectScheduleId,
    (instances, id) =>
        instances.firstWhereOrNull((s) => s.scheduleId.toString() == id));

final getMember = Memoized2((Member member, Map<String, Profile> profiles) {
  final profile = profiles[member.profileId.toString()];

  return member.copyWith(
      displayNameOverride: member.displayNameOverride ?? profile?.displayName);
});

Map<String, Profile> selectAllProfiles(AppState state) =>
    state.profiles.entities;

final selectScheduleInstanceForDate = createSelector3(
    selectScheduleInstanceSummary,
    groupMembersWithProfilesSelector,
    selectIsAdmin, (instance, members, canEditOthers) {
  if (instance == null) return null;

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

  // This is ugly but I needed an easy way to count the user's reply,
  // after grouping the members by their reply (where the user is not included).
  final ownReply = instance.myReply ?? instance.myDefaultReply;
  final userRepliedYes = ownReply == ReplyOptions.yes ? 1 : 0;
  final userRepliedNo = ownReply == ReplyOptions.no ? 1 : 0;
  final userRepliedUnknown = ownReply == null ? 1 : 0;

  final repliesGroups = [
    if (groupedMembers.containsKey(ReplyOptions.yes))
      ScheduleInstanceRepliesGroup(
        reply: ReplyOptions.yes,
        count: groupedMembers[ReplyOptions.yes]!.length + userRepliedYes,
        members: groupedMembers[ReplyOptions.yes]!,
      ),
    if (groupedMembers.containsKey(ReplyOptions.no))
      ScheduleInstanceRepliesGroup(
        reply: ReplyOptions.no,
        count: groupedMembers[ReplyOptions.no]!.length + userRepliedNo,
        members: groupedMembers[ReplyOptions.no]!,
      ),
    if (groupedMembers.containsKey(null))
      ScheduleInstanceRepliesGroup(
        reply: null,
        count: groupedMembers[null]!.length + userRepliedUnknown,
        members: groupedMembers[null]!,
      ),
  ];

  return ScheduleInstanceDetails(
    scheduleId: instance.scheduleId,
    groupId: instance.groupId,
    displayName: instance.displayName,
    instanceDate: instance.instanceDate,
    repliesGroups: repliesGroups,
    timezone: instance.timezone,
    myReply: instance.myReply,
    myDefaultReply: instance.myDefaultReply,
    myDefaultRule: instance.myDefaultRule,
    targetMemberId: instance.targetMemberId,
    canEditOthers: canEditOthers,
  );
});
