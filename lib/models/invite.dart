import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/invite_methods.dart';

part 'invite.freezed.dart';
part 'invite.g.dart';

@freezed
sealed class Invite with _$Invite {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Invite({
    required String id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required int memberId,
    required InviteMethods method,
    required String value,
  }) = _Invite;

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
}
