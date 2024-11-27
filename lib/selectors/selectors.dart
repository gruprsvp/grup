import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/members.dart';
import 'package:parousia/selectors/schedules.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:reselect/reselect.dart';
import 'package:rrule/rrule.dart';
import 'package:memoized/memoized.dart';

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

Iterable<DefaultReply> selectAllDefaultReplies(AppState state) =>
    state.defaultReplies.entities.values;

Iterable<Reply> selectAllReplies(AppState state) =>
    state.replies.entities.values;

final selectSchedules = createSelector3(
    selectScheduleEntities,
    selectGroupId,
    selectedDateRangeSelector,
    (schedules, groupId, range) => schedules.where((s) =>
        s.groupId.toString() == groupId &&
        (s.startDate.isBefore(range.start) ||
            (s.startDate.compareTo(range.start) >= 0 &&
                s.startDate.compareTo(range.end) <= 0))));

final selectSchedulesIds =
    createSelector1(selectSchedules, (schedules) => schedules.map((s) => s.id));

final selectDefaultReplies = createSelector2(
    selectAllDefaultReplies,
    selectSchedulesIds,
    (replies, scheduleIds) =>
        replies.where((r) => scheduleIds.contains(r.scheduleId)));

final selectReplies = createSelector3(
    selectAllReplies,
    selectSchedulesIds,
    selectedDateRangeSelector,
    (replies, scheduleIds, range) => replies.where((r) =>
        scheduleIds.contains(r.scheduleId) && range.contains(r.instanceDate)));

// TODO This shit should be better tested, and use reselect for memoization
final selectScheduleInstancesForSelectedDate = createSelector5(
    selectedDateRangeSelector,
    selectMyMember,
    selectSchedules,
    selectDefaultReplies,
    selectReplies,
    (range, myMember, schedules, defaultReplies, replies) =>
        schedules.expand((schedule) => getScheduleInstances(
              schedule: schedule,
              defaultReplies: defaultReplies,
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
  final profile = profiles[member.profileId.toString()];

  return member.copyWith(
      displayNameOverride: member.displayNameOverride ?? profile?.displayName);
});

Map<String, Profile> selectAllProfiles(AppState state) =>
    state.profiles.entities;

final selectMemberReplies = createSelector3(
    groupMembersSelector,
    selectScheduleInstanceSummary,
    selectAllProfiles,
    (members, instance, profiles) => getMemberReplies(
          targetMemberId: instance?.targetMemberId,
          members: members,
          replies: instance?.memberReplies ?? {},
          profiles: profiles,
        ));

final selectMemberDefaultOptions = createSelector3(
    groupMembersSelector,
    selectScheduleInstanceSummary,
    selectAllProfiles,
    (members, instance, profiles) => getMemberDefaultOptions(
          targetMemberId: instance?.targetMemberId,
          members: members,
          defaultOptions: instance?.memberDefaultOptions ?? {},
          profiles: profiles,
        ));

// TODO This should work the other way around, and be memoized
final selectScheduleInstanceForDate = createSelector4(
    selectScheduleInstanceSummary,
    selectMemberReplies,
    selectMemberDefaultOptions,
    selectIsAdmin,
    (instance, memberReplies, memberDefaultOptions, canEditOthers) {
  if (instance == null) return null;

  return ScheduleInstanceDetails(
    scheduleId: instance.scheduleId,
    groupId: instance.groupId,
    displayName: instance.displayName,
    instanceDate: instance.instanceDate,
    memberReplies: memberReplies,
    memberDefaultOptions: memberDefaultOptions,
    yesCount: instance.yesCount,
    myReply: instance.myReply,
    myDefaultOption: instance.myDefaultOption,
    targetMemberId: instance.targetMemberId,
    canEditOthers: canEditOthers,
  );
});
