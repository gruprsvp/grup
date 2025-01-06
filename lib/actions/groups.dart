import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:parousia/brick/brick.dart';

/// Dispatched when a group is selected and the group details screen should be opened.
@immutable
class GroupDetailsOpenAction {
  const GroupDetailsOpenAction(this.groupId);

  final String groupId;
}

/// Dispatched when a group is selected and the group schedule details screen should be opened.
@immutable
class GroupScheduleDetailsOpenAction {
  const GroupScheduleDetailsOpenAction(this.scheduleId);

  final String scheduleId;
}

/// Dispatched when requesting to refresh all groups.
@immutable
class GroupRefreshAllAction {
  final Completer<void> completer;

  GroupRefreshAllAction({completer}) : completer = completer ?? Completer();
}

/// Dispatched when requesting to delete a group.
@immutable
class GroupDeleteAction {
  const GroupDeleteAction(this.group);

  final Group group;
}

/// Dispatched when requesting to delete a schedule
@immutable
class GroupScheduleDeleteAction {
  const GroupScheduleDeleteAction(this.schedule);

  final Schedule schedule;
}
