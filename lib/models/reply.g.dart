// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReplyImpl _$$ReplyImplFromJson(Map<String, dynamic> json) => _$ReplyImpl(
      id: json['id'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      memberId: json['member_id'] as int,
      scheduleId: json['schedule_id'] as int,
      eventDate: DateTime.parse(json['event_date'] as String),
      selectedOption:
          $enumDecode(_$ReplyOptionsEnumMap, json['selected_option']),
    );

Map<String, dynamic> _$$ReplyImplToJson(_$ReplyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'member_id': instance.memberId,
      'schedule_id': instance.scheduleId,
      'event_date': instance.eventDate.toIso8601String(),
      'selected_option': _$ReplyOptionsEnumMap[instance.selectedOption]!,
    };

const _$ReplyOptionsEnumMap = {
  ReplyOptions.yes: 'yes',
  ReplyOptions.no: 'no',
};
