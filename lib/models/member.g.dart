// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MemberImpl _$$MemberImplFromJson(Map<String, dynamic> json) => _$MemberImpl(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      role: $enumDecode(_$GroupRolesEnumMap, json['role']),
      profiles: json['profiles'] == null
          ? null
          : Profile.fromJson(json['profiles'] as Map<String, dynamic>),
      displayNameOverride: json['display_name_override'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MemberImplToJson(_$MemberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'role': _$GroupRolesEnumMap[instance.role]!,
      'profiles': instance.profiles,
      'display_name_override': instance.displayNameOverride,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$GroupRolesEnumMap = {
  GroupRoles.admin: 'admin',
  GroupRoles.member: 'member',
};
