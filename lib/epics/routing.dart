import 'package:go_router/go_router.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

/// All epics that handle the navigation
Epic<RootState> createRouterEpics(GoRouter router) => combineEpics<RootState>([
      createRouterPushEpic(router),
      // TODO(borgoat): create epics and actions for other router events
    ]);

// Convert to object oriented epic
Epic<RootState> createRouterPushEpic(GoRouter router) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<NavigatePushAction>()
      .map((action) => router.push(action.location, extra: action.extra));
}
