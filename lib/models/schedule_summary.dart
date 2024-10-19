import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';

part 'schedule_summary.freezed.dart';

/// A schedule instance with replies, to be displayed in a list.
/// It's missing details about all the members in the group.
@freezed
sealed class ScheduleSummary with _$ScheduleSummary {
  const factory ScheduleSummary({
    required int scheduleId,
    required int groupId,
    required String displayName,
    required DateTime eventDate,
    required Map<int, ReplyOptions> memberReplies,
    required int yesCount,
    ReplyOptions? myReply,
    int? targetMemberId,
  }) = _ScheduleSummary;
}

/// A schedule instance with replies, to be displayed in a detailed view.
/// It includes details about all the members in the group.
@freezed
sealed class ScheduleEventDetails with _$ScheduleEventDetails {
  const factory ScheduleEventDetails({
    required int scheduleId,
    required int groupId,
    required String displayName,
    required DateTime eventDate,
    required List<(Member, ReplyOptions)> memberReplies,
    required int yesCount,
    ReplyOptions? myReply,
    int? targetMemberId,
    bool? canEditOthers,
  }) = _ScheduleEventDetails;
}
