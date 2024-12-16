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

createProfileEpics(ProfilesRepository profiles, StorageRepository storage) =>
    combineEpics<AppState>([
      _createRetrieveOneProfileEpic(profiles),
      _createSignOutEpic(profiles),
      _createUpdateProfileEpic(profiles, storage),
      _createUpdateOneProfileEpic(profiles),
      _createDeleteProfileEpic(profiles, storage),
      _loadOwnProfileOnSignInEpic,
      _navigateToAuthPageEpic,
      _navigateToProfilePageEpic,
    ]);

/// Once the user signs in, request to load own profile
Stream<dynamic> _loadOwnProfileOnSignInEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) =>
            // When the user signs in with Apple,
            // we have to wait for the user to be
            // updated with their display name
            // before we can load their profile.
            action.authState.event == AuthChangeEvent.signedIn ||
            action.authState.event == AuthChangeEvent.userUpdated ||
            action.authState.event == AuthChangeEvent.initialSession)
        .where((action) => action.authState.session != null)
        .map((action) => RequestRetrieveOne<Profile>(
            action.authState.session!.user.id.toString()));

/// Fetch 1 user profile from the database
Epic<AppState> _createRetrieveOneProfileEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<RequestRetrieveOne<Profile>>()
      .asyncMap(
        (action) => profiles
            .getProfileById(action.id)
            .then<dynamic>((profile) => SuccessRetrieveOne<Profile>(profile))
            .catchError((error) =>
                FailRetrieveOne<Profile>(id: action.id, error: error)),
      );
}

/// Redirect to the profile page when the user profile is loaded and has no name
Stream<dynamic> _navigateToProfilePageEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<SuccessRetrieveOne<Profile>>()
        .where((action) =>
            action.entity.id == store.state.auth.user?.id &&
            action.entity.displayName == null)
        .map((action) => NavigatePushAction(ProfileRoute().location));

/// When the user requests to update their profile
Epic<AppState> _createUpdateProfileEpic(
    ProfilesRepository profiles, StorageRepository storage) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<SaveProfileAction>().asyncMap(
        (action) async {
          final displayName = action.name;
          final image = action.image;

          final picture = image != null
              ? await storage.uploadPublicXFile(const Uuid().v7(), image)
              : store
                  .state.profiles.entities[store.state.auth.user!.id]?.picture;

          return UpdateOne<Profile>(
            Profile(
              id: store.state.auth.user!.id,
              displayName: displayName,
              picture: picture,
            ),
          );
        },
      );
}

/// Update 1 user profile in the database
Epic<AppState> _createUpdateOneProfileEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<UpdateOne<Profile>>()
      .asyncMap((action) => profiles
          .updateProfile(
              id: action.entity.id,
              displayName: action.entity.displayName,
              pictureUrl: action.entity.picture)
          .then<dynamic>((profile) => SuccessUpdateOne<Profile>(action.entity))
          .catchError((error) => FailUpdateOne<Profile>(
              entity: action.entity, error: error as Object)));
}

/// When the user requests to delete their profile
Epic<AppState> _createDeleteProfileEpic(
    ProfilesRepository profiles, StorageRepository storage) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<DeleteProfileAction>().asyncMap((action) async {
        final userId = store.state.auth.user!.id;
        await storage.deleteUserFiles();
        return profiles
            .deleteProfile()
            .then<dynamic>((_) => SuccessDeleteOne<Profile>(userId))
            .catchError((error) =>
                FailDeleteOne<Profile>(id: userId, error: error as Object));
      });
}

/// When the user profile is deleted, sign out
Epic<AppState> _createSignOutEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<SuccessDeleteOne<Profile>>().asyncMap((action) async {
        await profiles.signOut();
      });
}

/// When the user profile is deleted, redirect to the sign-in page
Stream<dynamic> _navigateToAuthPageEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<SuccessDeleteOne<Profile>>()
        .map((action) => NavigatePushAction(AuthRoute().location));
