import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/schedules.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// Provide the current theme mode.
ThemeMode themeModeSelector(RootState state) => state.themeMode;

/// Provide the user-configured locale.
Locale? localeSelector(RootState state) {
  final locale = state.locale;

  if (locale == null) return null;

  return Locale.fromSubtags(
    languageCode: locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  );
}

/// Provide the recurrence rule localised text encoder.
Future<RruleL10n> rruleL10nSelector(RootState state) {
  // TODO Support more locales
  // final locale = state.locale;

  return RruleL10nEn.create();
}

/// Provide the begin and end of day for the selected date.
DateTimeRange selectedDateRangeSelector(RootState state) =>
    state.selectedDate.getDayRange();

// TODO This shit should be tested
Iterable<ScheduleInstance>? selectSchedulesAndReplies(
    RootState state, int selectedGroupId) {
  final range = state.selectedDate.getDayRange();
  final group = state.groups.entities[selectedGroupId.toString()];

  if (group == null) return null;

  final schedules = state.schedules.entities.values.where(
      (s) => s.groupId == selectedGroupId && s.startDate.isBefore(range.start));
  final scheduleIds = schedules.map((s) => s.id);
  final defaultReplies = state.defaultReplies.entities.values
      .where((r) => scheduleIds.contains(r.scheduleId));
  final replies = state.replies.entities.values.where(
      (r) => scheduleIds.contains(r.scheduleId) && range.contains(r.eventDate));

  return schedules.expand((schedule) => getScheduleInstances(
      schedule: schedule,
      defaultReplies: defaultReplies,
      replies: replies,
      startDate: range.start,
      endDate: range.end));
}
