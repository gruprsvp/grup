import 'package:go_router/go_router.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

/// All epics that handle the navigation
Epic<AppState> createRouterEpics(GoRouter router) => combineEpics<AppState>([
      _createRouterPushEpic(router),
      _createRouterPopEpic(router),
      // TODO(borgoat): create epics and actions for other router events
    ]);

Epic<AppState> _createRouterPushEpic(GoRouter router) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<NavigatePushAction>()
      .map((action) => router.push(action.location, extra: action.extra));
}

Epic<AppState> _createRouterPopEpic(GoRouter router) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<NavigatePopAction>()
      .map((action) => router.pop(action.location));
}
