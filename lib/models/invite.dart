import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enum.dart';

part 'invite.freezed.dart';
part 'invite.g.dart';

@freezed
sealed class Invite with _$Invite {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Invite({
    required int id,
    required int memberId,
    required InviteMethods method,
    required String value,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Invite;

  factory Invite.fromJson(Map<String, dynamic> json) => _$InviteFromJson(json);
}

/// A contact to invite to a group.
class ContactInvite {
  final String? displayNameOverride;
  final List<(InviteMethods, String)> invites;

  const ContactInvite(this.displayNameOverride, this.invites);
}
