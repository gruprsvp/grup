import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
sealed class Member with _$Member {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Member({
    required String id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required int groupId,
    int? profileId,
    required int roleId,
    String? displayNameOverride,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
