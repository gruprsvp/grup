import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/repository.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase/supabase.dart';

/// All epics that handle auth
Epic<AppState> createAuthEpics() => combineEpics<AppState>([
  _navigateToLastRouteEpic,
  _deleteDatabaseOnSignOut,
]);

/// Redirect to the last route if the user is authenticated
Stream<dynamic> _navigateToLastRouteEpic(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) => actions
    .whereType<AuthStateChangedAction>()
    .where(
      (action) =>
          store.state.auth.user != null && store.state.auth.lastRoute != null,
    )
    .map((action) => HandleDeeplinkAction(store.state.auth.lastRoute!));

/// When a user signs out, delete the sqlite database
Stream<dynamic> _deleteDatabaseOnSignOut(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) => actions
    .whereType<AuthStateChangedAction>()
    .where((action) => action.authState.event == AuthChangeEvent.signedOut)
    .asyncMap(
      (action) => ParRepository().resetDatabase().then<dynamic>(
        (_) => SignOutSuccessAction(),
      ),
    );
