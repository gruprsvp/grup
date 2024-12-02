import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

/// All epics that handle auth
Epic<AppState> createAuthEpics() => combineEpics<AppState>([
      _navigateToLastRouteEpic,
    ]);

/// Redirect to the last route if the user is authenticated
Stream<dynamic> _navigateToLastRouteEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) =>
            store.state.auth.user != null && store.state.auth.lastRoute != null)
        .map((action) => HandleDeeplinkAction(store.state.auth.lastRoute!));
