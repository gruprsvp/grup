import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth.dart';
import 'locale.dart';
import 'remote_entities.dart';
import 'selected_date.dart';
import 'theme.dart';

/// The root reducer combines all the reducers for the app into one.
AppState rootReducer(AppState state, dynamic action) {
  // TODO: use combineReducers?
  if (action is AuthStateChangedAction &&
      action.authState.event == AuthChangeEvent.signedOut) {
    return AppState.initialState();
  }

  return AppState(
    groups: groupsReducer(state.groups, action),
    profiles: profilesReducer(state.profiles, action),
    schedules: schedulesReducer(state.schedules, action),
    defaultReplies: defaultRepliesReducer(state.defaultReplies, action),
    replies: repliesReducer(state.replies, action),
    auth: authReducer(state.auth, action),
    themeMode: themeReducer(state.themeMode, action),
    locale: localeReducer(state.locale, action),
    selectedDate: selectedDateReducer(state.selectedDate, action),
  );
}
