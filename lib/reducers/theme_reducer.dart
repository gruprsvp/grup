import 'package:flutter/material.dart';
import 'package:parousia/actions/actions.dart';
import 'package:redux/redux.dart';

final themeReducer = combineReducers<ThemeMode>([
  TypedReducer<ThemeMode, NextThemeAction>(_nextTheme),
]);

ThemeMode _nextTheme(ThemeMode themeMode, NextThemeAction action) {
  return ThemeMode.values[(themeMode.index - 1) % ThemeMode.values.length];
}
