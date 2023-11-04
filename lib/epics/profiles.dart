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

/// Once the user signs in, request to load own profile
Stream<dynamic> loadOwnProfileOnSignInEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) => action.authState.event == AuthChangeEvent.signedIn)
        .map((event) => RequestRetrieveOne<Profile>(
            event.authState.session!.user.id.toString()));

/// Fetch 1 user profile from the database
Epic<RootState> createRetrieveOneProfileEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<RequestRetrieveOne<Profile>>()
      .asyncMap(
        (action) => profiles
            .getProfileById(action.id)
            .then<dynamic>((profile) => OwnProfileLoadedAction(profile))
            .catchError((error) => OwnProfileLoadErrorAction(error as Object)),
      );
}

/// Redirect to the profile page when the user profile is loaded and has no name
Stream<dynamic> navigateToProfilePageEpic(
        Stream<dynamic> actions, EpicStore<RootState> store) =>
    actions
        .whereType<OwnProfileLoadedAction>()
        .where((action) => action.profile.displayName == null)
        .map((action) => NavigatePushAction(ProfileRoute().location));

/// When the user requests to update their profile
Epic<RootState> createUpdateProfileEpic(
    ProfilesRepository profiles, StorageRepository storage) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<UpdateProfileAction>().asyncMap(
        (action) async {
          final displayName = action.name;
          final image = action.image;

          final picture = image != null
              ? await storage.uploadPublicXFile(
                  const Uuid().v7(),
                  image,
                )
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

Epic<RootState> createUpdateOneProfileEpic(ProfilesRepository profiles) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
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
