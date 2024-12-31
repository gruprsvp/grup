import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

/// All epics that handle analytics
Epic<AppState> createAnalyticsEpics() => combineEpics<AppState>([
      _identifyUserEpic,
    ]);

/// Identify the user in PostHog
Stream<dynamic> _identifyUserEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<AuthStateChangedAction>()
        .where((action) => store.state.auth.user != null)
        .map((action) async {
      final email = store.state.auth.user!.email;
      await identifyUser(
          store.state.auth.user!.id, email != null ? {'email': email} : null);
    });
