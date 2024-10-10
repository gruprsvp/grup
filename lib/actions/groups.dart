import 'dart:async';

import 'package:flutter/foundation.dart';

/// Dispatched when a group is selected and the group details screen should be opened.
@immutable
class GroupDetailsOpenAction {
  const GroupDetailsOpenAction(this.groupId);

  final String groupId;
}

/// Dispatched when requesting to refresh all groups.
@immutable
class GroupRefreshAllAction {
  final Completer<void> completer;

  GroupRefreshAllAction({completer}) : completer = completer ?? Completer();
}
