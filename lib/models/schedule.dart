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
    required String groupId,
    required String displayName,
    required DateTime startDate,
    required RecurrenceRule recurrenceRule,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
