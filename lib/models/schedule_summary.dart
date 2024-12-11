import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';

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
    required Map<int, ReplyOptions> memberDefaultReplyOptions,
    required Map<int, DefaultReply> memberDefaultReplies,
    required int yesCount,
    ReplyOptions? myReply,
    ReplyOptions? myDefaultReplyOption,
    DefaultReply? myDefaultReply,
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
    required List<ScheduleInstanceMember> membersList,
    required int yesCount,
    ReplyOptions? myReply,
    ReplyOptions? myDefaultReplyOption,
    DefaultReply? myDefaultReply,
    int? targetMemberId,
    bool? canEditOthers,
  }) = _ScheduleInstanceDetails;
}

@freezed
sealed class ScheduleInstanceMember with _$ScheduleInstanceMember {
  const factory ScheduleInstanceMember.reply({
    required Member member,
    ReplyOptions? reply,
    ReplyOptions? defaultReplyOption,
    DefaultReply? defaultReply,
    Profile? profile,
  }) = ScheduleInstanceMemberReply;

  const factory ScheduleInstanceMember.separator({
    ReplyOptions? reply,
    ReplyOptions? defaultReplyOption,
    int? count,
  }) = ScheduleInstanceMemberSeparator;
}
