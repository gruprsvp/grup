part of 'selectors.dart';

User? selectAuthUser(AppState state) => state.auth.user;

final selectAuthUserId =
    createSelector1(selectAuthUser, (authUser) => authUser?.id);
