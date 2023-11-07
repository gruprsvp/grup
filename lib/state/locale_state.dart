import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_state.freezed.dart';
part 'locale_state.g.dart';

@freezed
sealed class LocaleState with _$LocaleState {
  const factory LocaleState({
    required String languageCode,
    String? scriptCode,
    String? countryCode,
  }) = _LocaleState;

  factory LocaleState.fromJson(Map<String, dynamic> json) =>
      _$LocaleStateFromJson(json);
}
