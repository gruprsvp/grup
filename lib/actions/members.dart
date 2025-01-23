import 'package:flutter/foundation.dart';
import 'package:parousia/brick/brick.dart';

/// Dispatched when a member is selected and the member details screen should be opened.
@immutable
class MemberDetailsOpenAction {
  const MemberDetailsOpenAction(this.memberId);

  final String memberId;
}

@immutable
class RequestDeleteMemberAction {
  final Member member;

  const RequestDeleteMemberAction({
    required this.member,
  });
}
