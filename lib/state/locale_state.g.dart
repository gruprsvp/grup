// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocaleState _$LocaleStateFromJson(Map<String, dynamic> json) => _LocaleState(
  languageCode: json['languageCode'] as String,
  scriptCode: json['scriptCode'] as String?,
  countryCode: json['countryCode'] as String?,
);

Map<String, dynamic> _$LocaleStateToJson(_LocaleState instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'scriptCode': instance.scriptCode,
      'countryCode': instance.countryCode,
    };
