import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/app.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/config.dart';
import 'package:parousia/util/util.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable runtime fetching of Google Fonts to avoid network requests
  // They must be bundled with assets
  // https://pub.dev/packages/google_fonts#bundling-fonts-when-releasing
  GoogleFonts.config.allowRuntimeFetching = false;

  // Add the Google Fonts license to the LicenseRegistry
  // https://pub.dev/packages/google_fonts#licensing-fonts
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  // Initialize PostHog
  await initPostHog();

  final configService = ConfigService();
  await configService.initialize();

  // TODO(borgoat): support more configuration files
  final supabaseConfigFile = await rootBundle.loadString(
    configService.config.supabaseConfigPath,
  );

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);

  final supabase = await Supabase.initialize(
    publishableKey: supabaseConfig.anonKey,
    url: supabaseConfig.apiUrl,
  );

  final store = await _initStore(supabase.client);

  // Propagate auth state changes to the store
  supabase.client.auth.onAuthStateChange.listen(
    (authState) => store.dispatch(AuthStateChangedAction(authState)),
  );

  // Propagate received deeplinks to the store
  AppLinks().uriLinkStream.listen(
    (uri) => store.dispatch(HandleDeeplinkAction(uri.path)),
  );

  kReleaseMode
      ? initSentry(() => runApp(ParApp(store: store)))
      : runApp(ParApp(store: store));
}

Future<Store<AppState>> _initStore(SupabaseClient supabase) async {
  final defaultRulesService = DefaultRulesService(supabase: supabase);
  final groupsService = GroupsService(supabase: supabase);
  final membersService = MembersService(supabase: supabase);
  final invitesService = InvitesService(supabase: supabase);
  final profilesService = ProfilesService(supabase: supabase);
  final repliesService = RepliesService(supabase: supabase);
  final schedulesService = SchedulesService(supabase: supabase);
  final storageService = StorageService(supabase: supabase);

  final epics = combineEpics<AppState>([
    createRouterEpics(router),
    createAuthEpics(),
    createDefaultRulesEpics(defaultRulesService),
    createGroupsEpics(groupsService, storageService),
    createMembersEpic(membersService),
    createInvitesEpics(invitesService),
    createProfileEpics(profilesService, storageService),
    createRepliesEpics(repliesService),
    createSchedulesEpics(schedulesService),
  ]);

  const storageLocation = kIsWeb
      ? FlutterSaveLocation.sharedPreferences
      : FlutterSaveLocation.documentFile;

  final persistor = Persistor<AppState>(
    storage: FlutterStorage(location: storageLocation),
    serializer: JsonSerializer(
      (json) =>
          json != null ? AppState.fromJson(json as Map<String, dynamic>) : null,
    ),
    transforms: Transforms(
      onSave: [(state) => AppState.copyWithoutErrors(state)],
      onLoad: [(state) => AppState.copyWithSelectedDateToday(state)],
    ),
  );

  AppState? localPersistedState = await persistor.load().catchError((e) {
    log('failed to load persisted state: $e');
    return null;
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
