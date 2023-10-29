import 'package:parousia/models/models.dart';
import 'package:supabase/supabase.dart';

/// Action to request to switch to the next theme.
class NextThemeAction {}

/// Action fired whenever the auth changed according to Supabase.
class AuthStateChangedAction {
  AuthStateChangedAction(this.event);

  final AuthChangeEvent event;
}

class GroupsLoadedAction {
  GroupsLoadedAction(this.groups);

  final List<Group> groups;
}

class GroupsErrorAction {
  GroupsErrorAction(this.error);

  final Object error;
}
