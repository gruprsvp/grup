import 'package:parousia/actions/actions.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Epic<RootState> createLoadGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .where((action) => action is AuthStateChangedAction)
      .where((action) =>
          (action as AuthStateChangedAction).event == AuthChangeEvent.signedIn)
      .asyncMap(
        (action) => groups
            .getUserGroups()
            .then<dynamic>((groups) => GroupsLoadedAction(groups.toList()))
            .catchError((error) => GroupsErrorAction(error as Object)),
      );
}
