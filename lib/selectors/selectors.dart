import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
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

// TODO This shit should be better tested, and use reselect for memoization
Iterable<ScheduleSummary>? selectSchedulesForSelectedDate(
    AppState state, int selectedGroupId) {
  final range = selectedDateRangeSelector(state);
  final group = state.groups.entities[selectedGroupId.toString()];

  if (group == null) return null;

  final schedules = state.schedules.entities.values.where((s) =>
      s.groupId == selectedGroupId &&
      (s.startDate.isBefore(range.start) ||
          (s.startDate.compareTo(range.start) >= 0 &&
              s.startDate.compareTo(range.end) <= 0)));
  final scheduleIds = schedules.map((s) => s.id);
  final defaultReplies = state.defaultReplies.entities.values
      .where((r) => scheduleIds.contains(r.scheduleId));
  final replies = state.replies.entities.values.where(
      (r) => scheduleIds.contains(r.scheduleId) && range.contains(r.eventDate));

  final myselfInGroup = state.members.entities.values
      .where((member) =>
          member.profileId != null &&
          member.groupId == group.id &&
          member.profileId == state.auth.user?.id)
      .firstOrNull;

  return schedules.expand((schedule) => getScheduleInstances(
        schedule: schedule,
        defaultReplies: defaultReplies,
        replies: replies,
        startDate: range.start,
        endDate: range.end,
        targetMemberId: myselfInGroup?.id,
      ));
}

// TODO This should work the other way around, and be memoized
ScheduleEventDetails? selectScheduleForDate(
    AppState state, int selectedGroupId, int selectedScheduleId) {
  final allScheduleInstances =
      selectSchedulesForSelectedDate(state, selectedGroupId);
  final scheduleSummary = allScheduleInstances
      ?.firstWhereOrNull((s) => s.scheduleId == selectedScheduleId);

  if (scheduleSummary == null) return null;

  Member getMember(int memberId) {
    final member = state.members.entities[memberId.toString()]!;
    final profile = state.profiles.entities[member.profileId.toString()];

    return member.copyWith(
        displayNameOverride:
            member.displayNameOverride ?? profile?.displayName);
  }

  final memberReplies = scheduleSummary.memberReplies.entries
      .map((e) => (getMember(e.key), e.value))
      .whereNot((e) =>
          e.$1.id ==
          scheduleSummary
              .targetMemberId) // Remove target user from the list below
      .toList();

  // TODO This should be a selector and memoized
  final canEditOthers = selectIsAdmin(state, selectedGroupId);

  return ScheduleEventDetails(
    scheduleId: scheduleSummary.scheduleId,
    groupId: scheduleSummary.groupId,
    displayName: scheduleSummary.displayName,
    eventDate: scheduleSummary.eventDate,
    memberReplies: memberReplies,
    yesCount: scheduleSummary.yesCount,
    myReply: scheduleSummary.myReply,
    targetMemberId: scheduleSummary.targetMemberId,
    canEditOthers: canEditOthers,
  );
}
