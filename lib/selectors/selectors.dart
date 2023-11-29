import 'package:flutter/material.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';

/// Provide the current theme mode.
ThemeMode themeModeSelector(RootState state) => state.themeMode;

/// Provide the user-configured locale.
Locale localeSelector(RootState state) {
  final locale = state.locale;

  return Locale.fromSubtags(
    languageCode: locale.languageCode,
    scriptCode: locale.scriptCode,
    countryCode: locale.countryCode,
  );
}

/// Provide the begin and end of day for the selected date.
DateTimeRange selectedDateRangeSelector(RootState state) =>
    state.selectedDate.getDayRange();
