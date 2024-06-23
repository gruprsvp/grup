import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';

part 'schedule_instance.freezed.dart';

/// A schedule instance with replies, to be displayed in a list.
/// It's missing details about all the members in the group.
@freezed
sealed class ScheduleInstance with _$ScheduleInstance {
  const factory ScheduleInstance({
    required int scheduleId,
    required int groupId,
    required String displayName,
    required DateTime eventDate,
    required int yesCount,
    ReplyOptions? myReply,
    int? targetMemberId,
  }) = _ScheduleInstance;
}
