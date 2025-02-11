import 'package:parousia/actions/actions.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';
import 'package:uuid/uuid.dart';

createGroupsEpics(GroupsRepository groups, StorageRepository storage) =>
    combineEpics<AppState>([
      _createRetrieveAllGroupsEpic(groups),
      _createRetrieveOneGroupEpic(groups),
      _createCreateOneGroupEpic(groups, storage),
      _createUpdateOneGroupEpic(groups, storage),
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
              (userGroups) => [
                SuccessRetrieveAll(userGroups.groups.toList(growable: false)),
                SuccessRetrieveAll(userGroups.members.toList(growable: false)),
                // This is many to avoid overwriting the user own profile
                SuccessRetrieveMany(userGroups.profiles.toList(growable: false))
              ],
            ),
      );
}

/// Retrieve a single group
Epic<AppState> _createRetrieveOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestRetrieveOne<Group>>().asyncMap(
            (action) => groups
                .getGroupById(action.id)
                .then<dynamic>((group) => SuccessRetrieveOne(group))
                .catchError(
                    (error) => FailRetrieveOne(id: action.id, error: error)),
          );
}

/// Create a group
Epic<AppState> _createCreateOneGroupEpic(
    GroupsRepository groups, StorageRepository storage) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<CreateGroupAction>().asyncMap(
        (action) async {
          final picture = action.image != null
              ? await storage.uploadPublicXFile(
                  const Uuid().v7(), action.image!)
              : null;

          final group = action.group.copyWith(picture: picture);

          return groups
              .createGroup(group)
              .then<dynamic>((group) => SuccessCreateOne(group))
              .catchError(
                  (error) => FailCreateOne(entity: group, error: error));
        },
      );
}

/// Update a group
Epic<AppState> _createUpdateOneGroupEpic(
    GroupsRepository groups, StorageRepository storage) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<UpdateGroupAction>().asyncMap(
        (action) async {
          final picture = action.image != null
              ? await storage.uploadPublicXFile(
                  const Uuid().v7(), action.image!)
              : null;

          final group = action.group.copyWith(picture: picture);

          return groups
              .updateGroup(group)
              .then<dynamic>((group) => SuccessUpdateOne(group))
              .catchError(
                  (error) => FailUpdateOne(entity: group, error: error));
        },
      );
}

/// Delete a group
Epic<AppState> _createDeleteOneGroupEpic(GroupsRepository groups) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<RequestDeleteOne<Group>>()
      .asyncMap(
        (action) => groups
            .deleteGroup(action.id)
            .then<dynamic>((_) => SuccessDeleteOne<Group>(action.id))
            .catchError(
                (error) => FailDeleteOne<Group>(id: action.id, error: error)),
      );
}

/// When a group is deleted, redirect to the home page
Stream<dynamic> _navigateToHomePageEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<SuccessDeleteOne<Group>>()
        .map((action) => NavigateReplaceAction(HomeScreenRoute().location));
