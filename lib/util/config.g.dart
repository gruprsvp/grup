// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Config _$ConfigFromJson(Map<String, dynamic> json) => _Config(
  supabaseConfigPath: json['supabaseConfigPath'] as String,
  socialAuthWebClientId: json['socialAuthWebClientId'] as String,
  socialAuthIosClientId: json['socialAuthIosClientId'] as String,
);

Map<String, dynamic> _$ConfigToJson(_Config instance) => <String, dynamic>{
  'supabaseConfigPath': instance.supabaseConfigPath,
  'socialAuthWebClientId': instance.socialAuthWebClientId,
  'socialAuthIosClientId': instance.socialAuthIosClientId,
};
