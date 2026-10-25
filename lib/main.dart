import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:parousia/app.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/config.dart';
import 'package:parousia/util/util.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Web URLs without '#', so shared links (https://grup.rsvp/join/CODE) open
  // the right page. The host must serve index.html for every path: Cloudflare
  // Pages does, as long as the site has no 404.html.
  usePathUrlStrategy();

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
  final supabaseConfigFile = await rootBundle.loadString(
    configService.config.supabaseConfigPath,
  );

  final supabaseConfig = SupabaseConfig.fromString(supabaseConfigFile);
  final backend = Uri.parse(supabaseConfig.apiUrl).host;

  final supabase = await Supabase.initialize(
    publishableKey: supabaseConfig.publishableKey,
    url: supabaseConfig.apiUrl,
  );

  final repositories = await Repositories.create(
    supabaseServices(supabase.client),
    legacyState: await takeLegacyState(),
  );

  // Analytics, like error reports (below), come from release builds only, so
  // debug and test runs don't count as real use. Only after the user says yes.
  if (kReleaseMode) {
    await initPostHog(
      backend: backend,
      enabled: repositories.settings.analytics ?? false,
    );
  }

  // Checked after launch, so a slow or missing network never holds up
  // startup. The web app is always the latest version.
  final updateRequired = ValueNotifier(false);
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    final info = await PackageInfo.fromPlatform();
    unawaited(
      AppVersionService()
          .updateRequired(
            version: info.version,
            platform: Platform.operatingSystem,
          )
          .then((required) => updateRequired.value = required),
    );
  }

  // Links that open the app (https://grup.rsvp/join/CODE) reach the router
  // through Flutter's deep linking, enabled on Android and iOS.
  final app = MultiProvider(
    providers: repositories.providers,
    child: ParApp(
      router: createRouter(repositories.auth),
      settings: repositories.settings,
      updateRequired: updateRequired,
    ),
  );

  kReleaseMode ? initSentry(() => runApp(app), backend: backend) : runApp(app);
}
