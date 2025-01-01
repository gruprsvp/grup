part of 'selectors.dart';

RemoteEntityState<Profile> profilesSelector(AppState state) => state.profiles;

final selectOwnProfile = createSelector2(selectAuthUserId, profilesSelector,
    (authUserId, profiles) => profiles.entities[authUserId]);
