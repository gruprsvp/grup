import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';

part 'schedule_instance.freezed.dart';

@freezed
sealed class ScheduleInstance with _$ScheduleInstance {
  const factory ScheduleInstance({
    required int scheduleId,
    required String displayName,
    required DateTime eventDate,
    required int yesCount,
    ReplyOptions? myReply,
  }) = _ScheduleInstance;
}
