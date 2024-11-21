import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';

part 'schedule_summary.freezed.dart';

/// A schedule instance with replies, to be displayed in a list.
/// It's missing details about all the members in the group.
@freezed
sealed class ScheduleInstanceSummary with _$ScheduleInstanceSummary {
  const factory ScheduleInstanceSummary({
    required int scheduleId,
    required int groupId,
    required String displayName,
    required DateTime instanceDate,
    required Map<int, ReplyOptions> memberReplies,
    required int yesCount,
    ReplyOptions? myReply,
    int? targetMemberId,
  }) = _ScheduleInstanceSummary;
}

/// A schedule instance with replies, to be displayed in a detailed view.
/// It includes details about all the members in the group.
@freezed
sealed class ScheduleInstanceDetails with _$ScheduleInstanceDetails {
  const factory ScheduleInstanceDetails({
    required int scheduleId,
    required int groupId,
    required String displayName,
    required DateTime instanceDate,
    required List<(Member, ReplyOptions?)> memberReplies,
    required int yesCount,
    ReplyOptions? myReply,
    int? targetMemberId,
    bool? canEditOthers,
  }) = _ScheduleInstanceDetails;
}
