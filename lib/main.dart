import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/app.dart';
import 'package:parousia/epics/epics.dart';
import 'package:parousia/reducers/reducers.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/config.dart';
import 'package:parousia/util/util.dart';
import 'package:path_provider/path_provider.dart';
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

  final configService = ConfigService();
  await configService.initialize();

  // TODO(borgoat): support more configuration files
  final supabaseConfigFile =
      await rootBundle.loadString(configService.config.supabaseConfigPath);

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);

  final supabase = await Supabase.initialize(
    anonKey: supabaseConfig.anonKey,
    url: supabaseConfig.apiUrl,
  );

  final store = await _initStore(supabase.client);

  // Propagate auth state changes to the store
  supabase.client.auth.onAuthStateChange
      .listen((authState) => store.dispatch(AuthStateChangedAction(authState)));

  // Propagate received deeplinks to the store
  AppLinks()
      .uriLinkStream
      .listen((uri) => store.dispatch(HandleDeeplinkAction(uri.path)));

  final screenshotsDirectory = await getTemporaryDirectory();
  print('screenshotsDirectory: $screenshotsDirectory');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => ParApp(store: store),
      availableLocales: AppLocalizations.supportedLocales,
      devices: [
        DeviceInfo.genericPhone(
          platform: TargetPlatform.iOS,
          id: '6_9',
          name: '6.9" Display',
          pixelRatio: 3,
          screenSize: Size(430, 932),
          safeAreas: EdgeInsets.only(top: 59, bottom: 34),
        ),
        DeviceInfo.genericTablet(
          platform: TargetPlatform.iOS,
          id: '12_9',
          name: '12.9" Display',
          pixelRatio: 2,
          screenSize: Size(1024, 1366),
          safeAreas: EdgeInsets.only(top: 59, bottom: 34),
        ),
        DeviceInfo.genericPhone(
          platform: TargetPlatform.android,
          id: 'galaxy',
          name: 'Galaxy Note 20 Ultra',
          pixelRatio: 4,
          screenSize: Size(360, 772),
          safeAreas: EdgeInsets.only(top: 36, bottom: 24),
        ),
        DeviceInfo.genericTablet(
          platform: TargetPlatform.android,
          id: 'tablet',
          name: 'Tablet',
          pixelRatio: 3,
          screenSize: Size(556, 796),
          safeAreas: EdgeInsets.only(top: 36, bottom: 24),
        ),
      ],
      tools: [
        ...DevicePreview.defaultTools,
        DevicePreviewScreenshot(
          multipleScreenshots: true,
          onScreenshot: screenshotAsFiles(screenshotsDirectory),
        ),
      ],
    ),
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
    createAuthEpics(),
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
