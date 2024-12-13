import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';

part 'schedule_summary.freezed.dart';

/// A schedule instance with replies, to be displayed in a list.
/// It's missing details about all the members in the group.
@freezed
sealed class ScheduleInstanceSummary with _$ScheduleInstanceSummary {
  const factory ScheduleInstanceSummary({
    required String scheduleId,
    required String groupId,
    required String displayName,
    required DateTime instanceDate,
    required Map<String, ReplyOptions> memberReplies,
    required Map<String, ReplyOptions> memberDefaultReplies,
    required Map<String, DefaultRule> memberDefaultRules,
    required int yesCount,
    ReplyOptions? myReply,
    ReplyOptions? myDefaultReply,
    DefaultRule? myDefaultRule,
    String? targetMemberId,
  }) = _ScheduleInstanceSummary;
}

/// A schedule instance with replies, to be displayed in a detailed view.
/// It includes details about all the members in the group.
@freezed
sealed class ScheduleInstanceDetails with _$ScheduleInstanceDetails {
  const factory ScheduleInstanceDetails({
    required String scheduleId,
    required String groupId,
    required String displayName,
    required DateTime instanceDate,
    required List<ScheduleInstanceMember> membersList,
    required int yesCount,
    ReplyOptions? myReply,
    ReplyOptions? myDefaultReply,
    DefaultRule? myDefaultRule,
    String? targetMemberId,
    bool? canEditOthers,
  }) = _ScheduleInstanceDetails;
}

@freezed
sealed class ScheduleInstanceMember with _$ScheduleInstanceMember {
  const factory ScheduleInstanceMember.reply({
    required Member member,
    ReplyOptions? reply,
    ReplyOptions? defaultReply,
    DefaultRule? defaultRule,
    Profile? profile,
  }) = ScheduleInstanceMemberReply;

  const factory ScheduleInstanceMember.separator({
    ReplyOptions? reply,
    ReplyOptions? defaultReply,
    int? count,
  }) = ScheduleInstanceMemberSeparator;
}
