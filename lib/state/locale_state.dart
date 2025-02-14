import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import

part 'locale_state.mapper.dart';

@MappableClass()
class LocaleState with LocaleStateMappable {
  final String languageCode;
  final String? scriptCode;
  final String? countryCode;

  const LocaleState({
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  });

  static final fromJson = LocaleStateMapper.fromJson;
}
