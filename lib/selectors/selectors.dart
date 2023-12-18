import 'package:flutter/material.dart';
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
