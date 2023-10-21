import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// A [HydratedCubit] which allows changing and storing the current theme mode.
class ThemeCubit extends HydratedCubit<ThemeMode> {
  /// Creates a [ThemeCubit] with the default system theme.
  ThemeCubit() : super(ThemeMode.system);

  /// Cycles through the available [ThemeMode]s.
  void nextTheme() {
    emit(ThemeMode.values[(state.index - 1) % ThemeMode.values.length]);
  }

  /// Sets the theme to the provided [theme].
  void setTheme(ThemeMode theme) => emit(theme);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) =>
      ThemeMode.values[json['theme'] as int];

  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {'theme': state.index};
}
