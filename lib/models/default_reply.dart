import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rrule/rrule.dart';

import 'enum.dart';

part 'default_reply.freezed.dart';

part 'default_reply.g.dart';

@freezed
sealed class DefaultRule with _$DefaultRule {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DefaultRule({
    required String memberId,
    required String scheduleId,
    required ReplyOptions selectedOption,
    required RecurrenceRule recurrenceRule,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DefaultRule;

  factory DefaultRule.fromJson(Map<String, dynamic> json) =>
      _$DefaultRuleFromJson(json);
}
