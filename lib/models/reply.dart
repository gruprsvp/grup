import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum.dart';

part 'reply.freezed.dart';

part 'reply.g.dart';

@freezed
sealed class Reply with _$Reply {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Reply({
    required int memberId,
    required int scheduleId,
    required DateTime instanceDate,
    required ReplyOptions selectedOption,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Reply;

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
}
