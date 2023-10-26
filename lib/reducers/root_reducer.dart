import 'package:parousia/reducers/theme_reducer.dart';
import 'package:parousia/state/state.dart';

/// The root reducer combines all the reducers for the app into one.
RootState rootReducer(RootState state, dynamic action) {
  return RootState(
    themeMode: themeReducer(state.themeMode, action),
  );
}
