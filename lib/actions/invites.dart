import 'package:flutter/foundation.dart';
import 'package:parousia/models/models.dart';

/// Dispatched when the user entered an invite code to join a group.
@immutable
class JoinWithInviteCodeAction {
  const JoinWithInviteCodeAction(this.code);

  final String code;
}

@immutable
class SuccessUseInviteCode {
  const SuccessUseInviteCode();

// TODO Could this be used to navigate to the group?
// final String groupId;
}

@immutable
class FailUseInviteCode {
  const FailUseInviteCode(this.error);

  final Object? error;
}

@immutable
class InviteGroupMembersAction {
  const InviteGroupMembersAction({
    required this.groupId,
    required this.contacts,
  });

  final String groupId;
  final List<ContactInvite> contacts;
}

@immutable
class NewMembersCreatedAction {
  const NewMembersCreatedAction(this.members);

  final List<(Member, ContactInvite)> members;
}
