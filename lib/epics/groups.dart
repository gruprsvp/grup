import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';

createGroupsEpics(GroupsRepository groups) => combineEpics<RootState>([
      _createRetrieveAllGroupsEpic(groups),
      _createCreateOneGroupEpic(groups),
      _loadGroupsOnSignInEpic,
    ]);

/// Once the user signs in, request to load all the groups
Stream<dynamic> _loadGroupsOnSignInEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) => action.authState.event == AuthChangeEvent.signedIn)
        .map((event) => const RequestRetrieveAll<Group>());

/// Fetch all the groups from the database
Epic<RootState> _createRetrieveAllGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<RequestRetrieveAll<Group>>().asyncMap(
            (action) => groups
                .getUserGroups()
                .then<dynamic>(
                    (groups) => SuccessRetrieveAll<Group>(groups.toList()))
                .catchError((error) => FailRetrieveAll<Group>(error)),
          );
}

Epic<RootState> _createCreateOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<RequestCreateOne<Group>>().asyncMap(
            (action) => groups
                .createGroup(action.entity.displayName)
                .then<dynamic>((group) => SuccessCreateOne<Group>(group))
                .catchError((error) =>
                    FailCreateOne<Group>(entity: action.entity, error: error)),
          );
}
