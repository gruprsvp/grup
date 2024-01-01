import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/app.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storePromise = _initStore();

  // TODO(borgoat): support more configuration files
  final supabaseConfigFile =
      await rootBundle.loadString('supabase/config/local_network.json');
  // await rootBundle.loadString('supabase/config/supabase_dev.json');

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);

  final supabasePromise = Supabase.initialize(
    anonKey: supabaseConfig.anonKey,
    url: supabaseConfig.apiUrl,
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
  const storageLocation = kIsWeb
      ? FlutterSaveLocation.sharedPreferences
      : FlutterSaveLocation.documentFile;

  final persistor = Persistor<RootState>(
    storage: FlutterStorage(location: storageLocation),
    serializer: JsonSerializer<RootState>(
      (json) => json != null
          ? RootState.fromJson(json as Map<String, dynamic>)
          : null,
    ),
  );

  RootState? localPersistedState = await persistor.load().catchError((e) {
    log('failed to load persisted state: $e');
  });

  final groupsRepository = GroupsRepository(supabase: supabase);
  final profilesRepository = ProfilesRepository(supabase: supabase);
  final schedulesRepository = SchedulesRepository(supabase: supabase);
  final storageRepository = StorageRepository(supabase: supabase);
  final defaultRepliesRepository = DefaultRepliesRepository(supabase: supabase);
  final repliesRepository = RepliesRepository(supabase: supabase);

  final epics = combineEpics<RootState>([
    createRouterEpics(router),
    createGroupsEpics(groupsRepository),
    createProfileEpics(profilesRepository, storageRepository),
    createSchedulesEpics(schedulesRepository),
    createDefaultRepliesEpics(defaultRepliesRepository),
    createRepliesEpics(repliesRepository),
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
