import 'package:parousia/actions/actions.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';

createGroupsEpics(GroupsRepository groups) => combineEpics<AppState>([
      _createRetrieveAllGroupsEpic(groups),
      _createRetrieveOneGroupEpic(groups),
      _createCreateOneGroupEpic(groups),
      _createUpdateOneGroupEpic(groups),
      _createDeleteOneGroupEpic(groups),
      _reloadGroupOnScheduleDateChange,
      _loadGroupsOnSignInEpic,
      _loadGroupsOnAppInitEpic,
      _loadGroupsOnInviteCodeUseEpic,
      _loadGroupOnGroupDetailsOpenEpic,
      _navigateToHomePageEpic,
    ]);

/// Once the user signs in, request to load all the groups
Stream<dynamic> _loadGroupsOnSignInEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) =>
            action.authState.event == AuthChangeEvent.signedIn ||
            action.authState.event == AuthChangeEvent.initialSession)
        .map((event) => const RequestRetrieveAll<Group>());

/// Once the app starts, request to load all the groups, if the user is signed in
Stream<dynamic> _loadGroupsOnAppInitEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<AppStartedAction>()
        .where((_) => store.state.auth.status == AuthStatus.authenticated)
        .map((event) => const RequestRetrieveAll<Group>());

/// Once the user uses an invite code, request to load all the groups
Stream<dynamic> _loadGroupsOnInviteCodeUseEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<SuccessUseInviteCode>()
        .map((event) => const RequestRetrieveAll<Group>());

/// Refresh the group details when the user opens the group details screen
Stream<dynamic> _loadGroupOnGroupDetailsOpenEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<GroupDetailsOpenAction>()
        .map((action) => RequestRetrieveOne<Group>(action.groupId));

/// Refresh the group details when the user changes the schedule date
Stream<dynamic> _reloadGroupOnScheduleDateChange(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SelectDateAction>().switchMap((_) async* {
      final selectedGroupId = store.state.selectedGroupId;
      if (selectedGroupId != null) {
        yield GroupDetailsOpenAction(selectedGroupId);
      }
      yield null; // or handle the null case appropriately
    }).where((action) => action != null);

/// Load all groups for the current user, together with their members and profiles.
/// If the action includes a Completer, complete, to handle the refresh indicator.
Epic<AppState> _createRetrieveAllGroupsEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .where((action) =>
          action is GroupRefreshAllAction ||
          action is RequestRetrieveAll<Group>)
      .switchMap(
        (action) => groups
            .getUserGroups()
            .whenComplete(() => action is GroupRefreshAllAction
                ? action.completer.complete()
                : null)
            .asStream() // TODO Would it be easier to dispatch 1 action here, and then rethink reducers?
            .expand(
              (userGroups) => userGroups.map(
                (group) => SuccessRetrieveOne(group),
              ),
            ),
      );
}

/// Retrieve a single group
Epic<AppState> _createRetrieveOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestRetrieveOne<Group>>().asyncMap(
            (action) => groups
                .getGroup(action.id)
                .then<dynamic>((group) => SuccessRetrieveOne(group))
                .catchError(
                    (error) => FailRetrieveOne(id: action.id, error: error)),
          );
}

/// Create a group
Epic<AppState> _createCreateOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<RequestCreateOne<Group>>()
      .asyncMap(
        (action) => groups
            .createGroup(action.entity)
            .then<dynamic>((group) => SuccessCreateOne(group))
            .catchError(
                (error) => FailCreateOne(entity: action.entity, error: error)),
      );
}

/// Update a group
Epic<AppState> _createUpdateOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<RequestUpdateOne<Group>>()
      .asyncMap(
        (action) => groups
            .updateGroup(action.entity)
            .then<dynamic>((group) => SuccessUpdateOne(group))
            .catchError(
                (error) => FailUpdateOne(entity: action.entity, error: error)),
      );
}

/// Delete a group
Epic<AppState> _createDeleteOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<GroupDeleteAction>().asyncMap(
            (action) => groups
                .deleteGroup(action.group)
                .then<dynamic>((_) => SuccessDeleteOne<Group>(action.group.id))
                .catchError((error) =>
                    FailDeleteOne<Group>(id: action.group.id, error: error)),
          );
}

/// When a group is deleted, redirect to the home page
Stream<dynamic> _navigateToHomePageEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<SuccessDeleteOne<Group>>()
        .map((action) => NavigateReplaceAction(HomeScreenRoute().location));
