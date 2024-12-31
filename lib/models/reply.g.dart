// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      memberId: json['member_id'] as String,
      scheduleId: json['schedule_id'] as String,
      instanceDate: DateTime.parse(json['instance_date'] as String),
      selectedOption:
          $enumDecode(_$ReplyOptionsEnumMap, json['selected_option']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'schedule_id': instance.scheduleId,
      'instance_date': instance.instanceDate.toIso8601String(),
      'selected_option': _$ReplyOptionsEnumMap[instance.selectedOption]!,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ReplyOptionsEnumMap = {
  ReplyOptions.yes: 'yes',
  ReplyOptions.no: 'no',
};
