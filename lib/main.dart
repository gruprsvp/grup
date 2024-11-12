import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/app.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/config.dart';
import 'package:parousia/util/util.dart';
import 'package:purchases_flutter/purchases_flutter.dart'
    show PurchasesConfiguration, Purchases;
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the configuration file depending on the environment
  final configService = ConfigService();
  await configService.initialize();

  // https://www.revenuecat.com/docs/getting-started/configuring-sdk#initialization
  final revenuecatApiKey = Platform.isAndroid
      ? configService.config.revenuecatGoogleApiKey
      : configService.config.revenuecatAppleApiKey;
  final purchasesConfigFuture =
      Purchases.configure(PurchasesConfiguration(revenuecatApiKey));

  final supabaseConfigFile =
      await rootBundle.loadString(configService.config.supabaseConfigPath);

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);

  final supabase = await Supabase.initialize(
    anonKey: supabaseConfig.anonKey,
    url: supabaseConfig.apiUrl,
  );

  final store = await _initStore(supabase.client);

  // Wait for the purchases configuration to be ready before starting the app
  await purchasesConfigFuture;

  // Propagate auth state changes to the store
  supabase.client.auth.onAuthStateChange
      .listen((authState) => store.dispatch(AuthStateChangedAction(authState)));

  runApp(
    ParApp(store: store),
  );
}

Future<Store<AppState>> _initStore(SupabaseClient supabase) async {
  final defaultRepliesRepository = DefaultRepliesRepository(supabase: supabase);
  final groupsRepository = GroupsRepository(supabase: supabase);
  final membersRepository = MembersRepository(supabase: supabase);
  final invitesRepository = InvitesRepository(supabase: supabase);
  final profilesRepository = ProfilesRepository(supabase: supabase);
  final repliesRepository = RepliesRepository(supabase: supabase);
  final schedulesRepository = SchedulesRepository(supabase: supabase);
  final storageRepository = StorageRepository(supabase: supabase);

  final epics = combineEpics<AppState>([
    createRouterEpics(router),
    createDefaultRepliesEpics(defaultRepliesRepository),
    createGroupsEpics(groupsRepository),
    createMembersEpic(membersRepository),
    createInvitesEpics(invitesRepository),
    createProfileEpics(profilesRepository, storageRepository),
    createRepliesEpics(repliesRepository),
    createSchedulesEpics(schedulesRepository),
  ]);

  const storageLocation = kIsWeb
      ? FlutterSaveLocation.sharedPreferences
      : FlutterSaveLocation.documentFile;

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(location: storageLocation),
    serializer: JsonSerializer((json) =>
        json != null ? AppState.fromJson(json as Map<String, dynamic>) : null),
    transforms: Transforms(
      onSave: [(state) => AppState.copyWithoutErrors(state)],
      onLoad: [(state) => AppState.copyWithSelectedDateToday(state)],
    ),
  );

  AppState? localPersistedState = await persistor.load().catchError((e) {
    log('failed to load persisted state: $e');
  });
  final initialState = localPersistedState ?? AppState.initialState();
  final middleware = [
    persistor.createMiddleware(),
    EpicMiddleware<AppState>(epics).call,
  ];

  return Store<AppState>(
    rootReducer,
    initialState: initialState,
    middleware: middleware,
  );
}
