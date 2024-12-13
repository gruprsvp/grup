import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/app.dart';
import 'package:parousia/brick/repository.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/config.dart';
import 'package:parousia/util/util.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
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

  final configService = ConfigService();
  await configService.initialize();

  // TODO(borgoat): support more configuration files
  final supabaseConfigFile =
      await rootBundle.loadString(configService.config.supabaseConfigPath);

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);

  await ParRepository.configure(
      supabaseUrl: supabaseConfig.apiUrl,
      supabaseAnonKey: supabaseConfig.anonKey);

  final repo = ParRepository();
  await repo.initialize();
  final supabaseClient = repo.remoteProvider.client;

  final store = await _initStore(supabaseClient);

  // Propagate auth state changes to the store
  supabaseClient.auth.onAuthStateChange
      .listen((authState) => store.dispatch(AuthStateChangedAction(authState)));

  // Propagate received deeplinks to the store
  AppLinks()
      .uriLinkStream
      .listen((uri) => store.dispatch(HandleDeeplinkAction(uri.path)));

  runApp(
    ParApp(store: store),
  );
}

Future<Store<AppState>> _initStore(SupabaseClient supabase) async {
  final defaultRulesRepository = DefaultRulesRepository(supabase: supabase);
  final groupsRepository = GroupsRepository(supabase: supabase);
  final membersRepository = MembersRepository(supabase: supabase);
  final invitesRepository = InvitesRepository(supabase: supabase);
  final profilesRepository = ProfilesRepository(supabase: supabase);
  final repliesRepository = RepliesRepository(supabase: supabase);
  final schedulesRepository = SchedulesRepository(supabase: supabase);
  final storageRepository = StorageRepository(supabase: supabase);

  final epics = combineEpics<AppState>([
    createRouterEpics(router),
    createAuthEpics(),
    createDefaultRulesEpics(defaultRulesRepository),
    createGroupsEpics(groupsRepository),
    createMembersEpic(membersRepository),
    createInvitesEpics(invitesRepository),
    createProfileEpics(profilesRepository, storageRepository),
    createRepliesEpics(repliesRepository),
    createSchedulesEpics(schedulesRepository),
  ]);

  final initialState = AppState.initialState();
  final middleware = [
    EpicMiddleware<AppState>(epics).call,
  ];

  return Store<AppState>(
    rootReducer,
    initialState: initialState,
    middleware: middleware,
  );
}
