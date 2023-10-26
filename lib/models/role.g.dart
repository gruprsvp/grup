// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoleImpl _$$RoleImplFromJson(Map<String, dynamic> json) => _$RoleImpl(
      id: json['id'] as int,
      displayName: json['display_name'] as String,
      canManageGroup: json['can_manage_group'] as bool,
      canManageMembers: json['can_manage_members'] as bool,
      canManageInvites: json['can_manage_invites'] as bool,
      canManageSchedules: json['can_manage_schedules'] as bool,
      canManageReplies: json['can_manage_replies'] as bool,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$RoleImplToJson(_$RoleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'display_name': instance.displayName,
      'can_manage_group': instance.canManageGroup,
      'can_manage_members': instance.canManageMembers,
      'can_manage_invites': instance.canManageInvites,
      'can_manage_schedules': instance.canManageSchedules,
      'can_manage_replies': instance.canManageReplies,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
