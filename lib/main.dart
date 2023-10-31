import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parousia/app.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'actions/actions.dart';
import 'router.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storePromise = _initStore();

  // TODO(borgoat): move this to a config file to support different environments
  final supabasePromise = Supabase.initialize(
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdxeXd1YXF5d3RjemZocGNubHFtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODg3NjIzMTEsImV4cCI6MjAwNDMzODMxMX0.m5Yg9Qu3xMzOFTA4cqxcen3ndOG2MVtWqbItK3r1al4',
    url: 'https://gqywuaqywtczfhpcnlqm.supabase.co',
    debug: kDebugMode,
  );

  await supabasePromise;

  final store = await storePromise;

  // Propagate auth state changes to the store
  supabase.auth.onAuthStateChange
      .listen((authState) => store.dispatch(AuthStateChangedAction(authState)));

  runApp(
    ParApp(store: store),
  );
}

Future<Store<RootState>> _initStore() async {
  final persistor = Persistor<RootState>(
    storage: FlutterStorage(),
    serializer: JsonSerializer<RootState>(
      (json) => json != null
          ? RootState.fromJson(json as Map<String, dynamic>)
          : null,
    ),
  );

  final localPersistedState = await persistor.load();

  final groupsRepository = GroupsRepository(supabase: supabase);
  final profilesRepository = ProfilesRepository(supabase: supabase);

  final epics = combineEpics<RootState>([
    createRouterEpics(router),
    createLoadGroupsEpic(groupsRepository),
    createLoadOwnProfileEpic(profilesRepository),
    createNavigateToProfilePageEpic(),
  ]);

  final initialState = localPersistedState ?? RootState.initialState();
  final middleware = [
    persistor.createMiddleware(),
    EpicMiddleware<RootState>(epics).call,
  ];

  // if (!kDebugMode) {
  return Store<RootState>(
    rootReducer,
    initialState: initialState,
    middleware: middleware,
  );
  // }
  // const host = String.fromEnvironment(
  //   'REMOTE_DEVTOOLS_HOST',
  //   defaultValue: '10.0.2.2:8000',
  //   // Android emulator host as default
  //   // https://developer.android.com/studio/run/emulator-networking.html
  // );
  // final remoteDevtools = RemoteDevToolsMiddleware(host);
  // final store = DevToolsStore<RootState>(
  //   rootReducer,
  //   initialState: initialState,
  //   middleware: [
  //     ...middleware,
  //     remoteDevtools.call,
  //   ],
  // );
  // remoteDevtools.store = store;
  // await remoteDevtools.connect();
  // return store;
}
