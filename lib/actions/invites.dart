import 'package:flutter/foundation.dart';

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
