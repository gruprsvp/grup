// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as int,
      displayName: json['display_name'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
