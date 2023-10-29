import 'package:go_router/go_router.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';

import 'routing.dart';

// TODO(borgoat): create some helpers to filter actions by type and event

Epic<RootState> createRouterEpics(GoRouter router) => combineEpics<RootState>([
      createRouterPushEpic(router),
    ]);

Epic<RootState> createLoadGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<AuthStateChangedAction>()
      .where((action) => action.authState.event == AuthChangeEvent.signedIn)
      .asyncMap(
        (action) => groups
            .getUserGroups()
            .then<dynamic>((groups) => GroupsLoadedAction(groups.toList()))
            .catchError((error) => GroupsLoadErrorAction(error as Object)),
      );
}

Epic<RootState> createLoadOwnProfileEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<AuthStateChangedAction>()
      .where((action) => action.authState.event == AuthChangeEvent.signedIn)
      .asyncMap(
        (action) => profiles
            .getOwnProfile()
            .then<dynamic>((profile) => OwnProfileLoadedAction(profile))
            .catchError((error) => OwnProfileLoadErrorAction(error as Object)),
      );
}

Epic<RootState> createNavigateToProfilePageEpic() {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<OwnProfileLoadedAction>()
      .where((action) => action.profile.displayName == null)
      .map((action) => NavigatePushAction(ProfileRoute().location));
}
