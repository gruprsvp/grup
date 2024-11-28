import 'package:flutter/foundation.dart';

/// Dispatched when a member is selected and the member details screen should be opened.
@immutable
class MemberDetailsOpenAction {
  const MemberDetailsOpenAction(this.memberId);

  final String memberId;
}
