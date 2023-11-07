// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocaleStateImpl _$$LocaleStateImplFromJson(Map<String, dynamic> json) =>
    _$LocaleStateImpl(
      languageCode: json['languageCode'] as String,
      scriptCode: json['scriptCode'] as String?,
      countryCode: json['countryCode'] as String?,
    );

Map<String, dynamic> _$$LocaleStateImplToJson(_$LocaleStateImpl instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'scriptCode': instance.scriptCode,
      'countryCode': instance.countryCode,
    };
