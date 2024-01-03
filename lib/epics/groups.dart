import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';

createGroupsEpics(GroupsRepository groups) => combineEpics<RootState>([
      _createRefreshRetrieveAllGroupsEpic(groups),
      _createRetrieveAllGroupsEpic(groups),
      _createRetrieveOneGroupEpic(groups),
      _createCreateOneGroupEpic(groups),
      _createUpdateOneGroupEpic(groups),
      _loadGroupsOnSignInEpic,
      _loadGroupsOnAppInitEpic,
      _loadGroupsOnInviteCodeUseEpic,
      _loadGroupOnGroupDetailsOpenEpic
    ]);

/// Once the user signs in, request to load all the groups
Stream<dynamic> _loadGroupsOnSignInEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) => action.authState.event == AuthChangeEvent.signedIn)
        .map((event) => const RequestRetrieveAll<Group>());

/// Once the app starts, request to load all the groups, if the user is signed in
Stream<dynamic> _loadGroupsOnAppInitEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<AppStartedAction>()
        .where((_) => store.state.auth.status == AuthStatus.authenticated)
        .map((event) => const RequestRetrieveAll<Group>());

Stream<dynamic> _loadGroupsOnInviteCodeUseEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<SuccessUseInviteCode>()
        .map((event) => const RequestRetrieveAll<Group>());

/// Refresh the group details when the user opens the group details screen
Stream<dynamic> _loadGroupOnGroupDetailsOpenEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<GroupDetailsOpenAction>()
        .map((action) => RequestRetrieveOne<Group>(action.groupId));

/// Let user refresh the groups, with an action including a Completer, to handle the refresh indicator.
Epic<RootState> _createRefreshRetrieveAllGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<GroupRefreshAllAction>()
      .asyncMap(
        (action) => groups
            .getUserGroups()
            .then<dynamic>(
                (groups) => SuccessRetrieveAll(groups.toList(growable: false)))
            .catchError((error) => FailRetrieveAll(error))
            .whenComplete(() => action.completer.complete()),
      );
}

/// Fetch all the groups from the database
Epic<RootState> _createRetrieveAllGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<RequestRetrieveAll<Group>>()
      .asyncMap(
        (action) => groups
            .getUserGroups()
            .then<dynamic>(
                (groups) => SuccessRetrieveAll(groups.toList(growable: false)))
            .catchError((error) => FailRetrieveAll(error)),
      );
}

Epic<RootState> _createRetrieveOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<RequestRetrieveOne<Group>>().asyncMap(
            (action) => groups
                .getGroupById(int.parse(action.id))
                .then<dynamic>((group) => SuccessRetrieveOne(group))
                .catchError(
                    (error) => FailRetrieveOne(id: action.id, error: error)),
          );
}

Epic<RootState> _createCreateOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<RequestCreateOne<Group>>()
      .asyncMap(
        (action) => groups
            .createGroup(action.entity)
            .then<dynamic>((group) => SuccessCreateOne(group))
            .catchError(
                (error) => FailCreateOne(entity: action.entity, error: error)),
      );
}

Epic<RootState> _createUpdateOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<RequestUpdateOne<Group>>()
      .asyncMap(
        (action) => groups
            .updateGroup(action.entity)
            .then<dynamic>((group) => SuccessUpdateOne(group))
            .catchError(
                (error) => FailUpdateOne(entity: action.entity, error: error)),
      );
}
