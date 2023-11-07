import 'package:parousia/state/state.dart';

import 'auth.dart';
import 'locale.dart';
import 'remote_entities.dart';
import 'theme.dart';

/// The root reducer combines all the reducers for the app into one.
RootState rootReducer(RootState state, dynamic action) {
  return RootState(
    groups: groupsReducer(state.groups, action),
    profiles: profilesReducer(state.profiles, action),
    schedules: schedulesReducer(state.schedules, action),
    defaultReplies: defaultRepliesReducer(state.defaultReplies, action),
    replies: repliesReducer(state.replies, action),
    auth: authReducer(state.auth, action),
    themeMode: themeReducer(state.themeMode, action),
    locale: localeReducer(state.locale, action),
  );
}
