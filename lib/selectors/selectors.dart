import 'package:flutter/material.dart';
import 'package:parousia/state/state.dart';

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
