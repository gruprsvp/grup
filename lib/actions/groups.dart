import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';

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

/// Dispatched when a group is created or updated.
@immutable
class CreateGroupAction {
  const CreateGroupAction({required this.group, this.image});

  final Group group;
  final XFile? image;
}

/// Dispatched when a group is updated.
@immutable
class UpdateGroupAction {
  const UpdateGroupAction({required this.group, this.image});

  final Group group;
  final XFile? image;
}
