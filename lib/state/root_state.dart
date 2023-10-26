import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'root_state.freezed.dart';
part 'root_state.g.dart';

@freezed
sealed class RootState with _$RootState {
  const factory RootState({
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _RootState;

  factory RootState.initialState() => const RootState();

  factory RootState.fromJson(Map<String, dynamic> json) =>
      _$RootStateFromJson(json);
}
