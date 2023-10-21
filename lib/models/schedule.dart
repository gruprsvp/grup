import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rrule/rrule.dart';

part 'schedule.freezed.dart';

part 'schedule.g.dart';

@freezed
sealed class Schedule with _$Schedule {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Schedule({
    required String id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required int groupId,
    required String displayName,
    required RecurrenceRule recurrenceRule,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
