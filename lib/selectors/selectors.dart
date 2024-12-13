import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:memoized/memoized.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/selectors/members.dart';
import 'package:parousia/selectors/schedules.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:reselect/reselect.dart';
import 'package:rrule/rrule.dart';

export 'members.dart';

// TODO Move everything to separate files

/// Provide the current theme mode.
ThemeMode themeModeSelector(AppState state) => state.themeMode;

/// Provide the user-configured locale.
Locale? localeSelector(AppState state) {
  final locale = state.locale;

  if (locale == null) return null;

  return Locale.fromSubtags(
    languageCode: locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  );
}

/// Provide the recurrence rule localised text encoder.
Future<RruleL10n> rruleL10nSelector(AppState state) {
  // TODO Support more locales
  // final locale = state.locale;

  return RruleL10nEn.create();
}

DateTime selectedDateSelector(AppState state) => state.selectedDate;

/// Provide the begin and end of day for the selected date.
final selectedDateRangeSelector =
    createSelector1(selectedDateSelector, (date) => date.getDayRange());

String? selectGroupId(AppState state) => state.selectedGroupId;

Map<String, Group> selectGroupEntities(AppState state) => state.groups.entities;

final selectGroup = createSelector2(
    selectGroupId, selectGroupEntities, (id, entities) => entities[id]);

Iterable<Schedule> selectScheduleEntities(AppState state) =>
    state.schedules.entities.values;

Iterable<DefaultRule> selectAllDefaultRules(AppState state) =>
    state.defaultRules.entities.values;

Iterable<Reply> selectAllReplies(AppState state) =>
    state.replies.entities.values;

final selectSchedules = createSelector3(
    selectScheduleEntities,
    selectGroupId,
    selectedDateRangeSelector,
    (schedules, groupId, range) => schedules.where((s) =>
        s.group.id.toString() == groupId &&
        (s.startDate.isBefore(range.start) ||
            (s.startDate.compareTo(range.start) >= 0 &&
                s.startDate.compareTo(range.end) <= 0))));

final selectSchedulesIds =
    createSelector1(selectSchedules, (schedules) => schedules.map((s) => s.id));

final selectDefaultRules = createSelector2(
    selectAllDefaultRules,
    selectSchedulesIds,
    (replies, scheduleIds) =>
        replies.where((r) => scheduleIds.contains(r.schedule.id)));

final selectReplies = createSelector3(
    selectAllReplies,
    selectSchedulesIds,
    selectedDateRangeSelector,
    (replies, scheduleIds, range) => replies.where((r) =>
        scheduleIds.contains(r.schedule.id) && range.contains(r.instanceDate)));

final selectScheduleInstancesForSelectedDate = createSelector5(
    selectedDateRangeSelector,
    selectMyMember,
    selectSchedules,
    selectDefaultRules,
    selectReplies,
    (range, myMember, schedules, defaultRules, replies) =>
        schedules.expand((schedule) => getScheduleInstances(
              schedule: schedule,
              defaultRules: defaultRules,
              replies: replies,
              startDate: range.start,
              endDate: range.end,
              targetMemberId: myMember?.$1.id,
            )));

String? selectScheduleId(AppState state) => state.selectedScheduleId;

final selectScheduleInstanceSummary = createSelector2(
    selectScheduleInstancesForSelectedDate,
    selectScheduleId,
    (instances, id) =>
        instances.firstWhereOrNull((s) => s.scheduleId.toString() == id));

final getMember = Memoized2((Member member, Map<String, Profile> profiles) {
  final profile = profiles[member.profile?.id.toString()];

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
        (m) => ScheduleInstanceMember.reply(
          member: m.$1,
          reply: instance.memberReplies[m.$1.id],
          defaultReply: instance.memberDefaultReplies[m.$1.id],
          defaultRule: instance.memberDefaultRules[m.$1.id],
          profile: m.$2,
        ),
      )
      .whereNot((m) =>
          (m as ScheduleInstanceMemberReply).member.id ==
          instance.targetMemberId)
      .groupListsBy((m) => m.reply ?? m.defaultReply);

  // This is ugly but I needed an easy way to count the user's reply,
  // after grouping the members by their reply (where the user is not included).
  final ownReply = instance.myReply ?? instance.myDefaultReply;
  final userRepliedYes = ownReply == ReplyOptions.yes ? 1 : 0;
  final userRepliedNo = ownReply == ReplyOptions.no ? 1 : 0;
  final userRepliedUnknown = ownReply == null ? 1 : 0;

  final membersList = [
    if (groupedMembers.containsKey(ReplyOptions.yes)) ...[
      ScheduleInstanceMember.separator(
        reply: ReplyOptions.yes,
        count: groupedMembers[ReplyOptions.yes]!.length + userRepliedYes,
      ),
      ...groupedMembers[ReplyOptions.yes]!,
    ],
    if (groupedMembers.containsKey(ReplyOptions.no)) ...[
      ScheduleInstanceMember.separator(
        reply: ReplyOptions.no,
        count: groupedMembers[ReplyOptions.no]!.length + userRepliedNo,
      ),
      ...groupedMembers[ReplyOptions.no]!,
    ],
    if (groupedMembers.containsKey(null)) ...[
      ScheduleInstanceMember.separator(
        reply: null,
        count: groupedMembers[null]!.length + userRepliedUnknown,
      ),
      ...groupedMembers[null]!,
    ],
  ];

  return ScheduleInstanceDetails(
    scheduleId: instance.scheduleId,
    groupId: instance.groupId,
    displayName: instance.displayName,
    instanceDate: instance.instanceDate,
    membersList: membersList,
    yesCount: instance.yesCount,
    myReply: instance.myReply,
    myDefaultReply: instance.myDefaultReply,
    myDefaultRule: instance.myDefaultRule,
    targetMemberId: instance.targetMemberId,
    canEditOthers: canEditOthers,
  );
});
