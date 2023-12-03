// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefaultReplyImpl _$$DefaultReplyImplFromJson(Map<String, dynamic> json) =>
    _$DefaultReplyImpl(
      id: json['id'] as int,
      memberId: json['member_id'] as int,
      scheduleId: json['schedule_id'] as int,
      selectedOption:
          $enumDecode(_$ReplyOptionsEnumMap, json['selected_option']),
      recurrenceRule: RecurrenceRule.fromJson(
          json['recurrence_rule'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$DefaultReplyImplToJson(_$DefaultReplyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'schedule_id': instance.scheduleId,
      'selected_option': _$ReplyOptionsEnumMap[instance.selectedOption]!,
      'recurrence_rule': instance.recurrenceRule,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ReplyOptionsEnumMap = {
  ReplyOptions.yes: 'yes',
  ReplyOptions.no: 'no',
};
