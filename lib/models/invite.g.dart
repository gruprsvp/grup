// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InviteImpl _$$InviteImplFromJson(Map<String, dynamic> json) => _$InviteImpl(
      id: json['id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      memberId: json['member_id'] as int,
      method: $enumDecode(_$InviteMethodsEnumMap, json['method']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$$InviteImplToJson(_$InviteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'member_id': instance.memberId,
      'method': _$InviteMethodsEnumMap[instance.method]!,
      'value': instance.value,
    };

const _$InviteMethodsEnumMap = {
  InviteMethods.email: 'email',
  InviteMethods.phone: 'phone',
  InviteMethods.code: 'code',
};
