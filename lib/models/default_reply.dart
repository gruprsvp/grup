import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rrule/rrule.dart';

import 'enum.dart';

part 'default_reply.freezed.dart';
part 'default_reply.g.dart';

@freezed
sealed class DefaultReply with _$DefaultReply {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DefaultReply({
    required String id,
    required int memberId,
    required int scheduleId,
    required ReplyOptions selectedOption,
    required RecurrenceRule recurrenceRule,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _DefaultReply;

  factory DefaultReply.fromJson(Map<String, dynamic> json) =>
      _$DefaultReplyFromJson(json);
}
