// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleImpl _$$ScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleImpl(
      id: json['id'] as int,
      groupId: json['group_id'] as int,
      displayName: json['display_name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      recurrenceRule: RecurrenceRule.fromJson(
          json['recurrence_rule'] as Map<String, dynamic>),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Reply.fromJson(e as Map<String, dynamic>)),
      defaultReplies: (json['default_replies'] as List<dynamic>?)
          ?.map((e) => DefaultReply.fromJson(e as Map<String, dynamic>)),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ScheduleImplToJson(_$ScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'display_name': instance.displayName,
      'start_date': instance.startDate.toIso8601String(),
      'recurrence_rule': instance.recurrenceRule,
      'replies': instance.replies?.toList(),
      'default_replies': instance.defaultReplies?.toList(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
