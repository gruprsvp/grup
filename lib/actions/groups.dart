import 'package:flutter/foundation.dart';
import 'package:parousia/models/models.dart';

@immutable
class GroupsLoadedAction {
  const GroupsLoadedAction(this.groups);

  final List<Group> groups;
}

@immutable
class GroupsLoadErrorAction {
  const GroupsLoadErrorAction(this.error);

  final Object error;
}
