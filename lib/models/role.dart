import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';
part 'role.g.dart';

@freezed
sealed class Role with _$Role {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Role({
    required int id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required String displayName,
    required bool canManageGroup,
    required bool canManageMembers,
    required bool canManageInvites,
    required bool canManageSchedules,
    required bool canManageReplies,
  }) = _Role;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
}
