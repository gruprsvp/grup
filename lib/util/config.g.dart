// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigImpl _$$ConfigImplFromJson(Map<String, dynamic> json) => _$ConfigImpl(
      supabaseConfigPath: json['supabaseConfigPath'] as String,
      socialAuthWebClientId: json['socialAuthWebClientId'] as String,
      socialAuthIosClientId: json['socialAuthIosClientId'] as String,
    );

Map<String, dynamic> _$$ConfigImplToJson(_$ConfigImpl instance) =>
    <String, dynamic>{
      'supabaseConfigPath': instance.supabaseConfigPath,
      'socialAuthWebClientId': instance.socialAuthWebClientId,
      'socialAuthIosClientId': instance.socialAuthIosClientId,
    };
