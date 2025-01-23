import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';

part 'schedule_summary.freezed.dart';

/// A schedule instance with replies, to be displayed in a list.
/// It's missing details about all the members in the group.
@freezed
sealed class ScheduleInstanceSummary with _$ScheduleInstanceSummary {
  const factory ScheduleInstanceSummary({
    required Schedule schedule,
    required String groupId,
    required String displayName,
    required DateTime instanceDate,
    required Map<String, Reply> memberReplies,
    required Map<String, Reply> memberDefaultReplies,
    required Map<String, DefaultRule> memberDefaultRules,
    required int yesCount,
    Reply? myReply,
    Reply? myDefaultReply,
    DefaultRule? myDefaultRule,
    Member? targetMember,
  }) = _ScheduleInstanceSummary;
}

/// A schedule instance with replies, to be displayed in a detailed view.
/// It includes details about all the members in the group.
@freezed
sealed class ScheduleInstanceDetails with _$ScheduleInstanceDetails {
  const factory ScheduleInstanceDetails({
    required Schedule schedule,
    required String groupId,
    required String displayName,
    required DateTime instanceDate,
    required List<ScheduleInstanceRepliesGroup> repliesGroups,
    Reply? myReply,
    Reply? myDefaultReply,
    DefaultRule? myDefaultRule,
    Member? targetMember,
    bool? canEditOthers,
  }) = _ScheduleInstanceDetails;
}

@freezed
sealed class ScheduleInstanceRepliesGroup with _$ScheduleInstanceRepliesGroup {
  const factory ScheduleInstanceRepliesGroup({
    required ReplyOptions? reply,
    required int count,
    required List<ScheduleInstanceMember> members,
  }) = _ScheduleInstanceRepliesGroup;
}

@freezed
sealed class ScheduleInstanceMember with _$ScheduleInstanceMember {
  const factory ScheduleInstanceMember({
    required Member member,
    Reply? reply,
    Reply? defaultReply,
    DefaultRule? defaultRule,
    Profile? profile,
  }) = _ScheduleInstanceMemberReply;
}
