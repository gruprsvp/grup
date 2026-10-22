import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/l10n/auth_ui_localizations.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:phone_form_field/phone_form_field.dart';

// Brand palette, for reference:
//   light: 0xFF34558B 0xFF007DAF 0xFF00A4B8 0xFF00C8A5 0xFF8BE585 0xFFF9F871
//   dark:  0xFF000025 0xFF001749 0xFF003E52 0xFF00623F 0xFF257F1F 0xFF93920B
final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF34558B),
  secondary: const Color(0xFF00A4B8),
  tertiary: const Color(0xFF8BE585),
);

final _darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF93920B),
  secondary: const Color(0xFF00623F),
  tertiary: const Color(0xFF257F1F),
);

/// The app's theme. Widget tests and the store-screenshot harness use it too,
/// so they render what users see.
ThemeData appTheme(Brightness brightness) => ThemeData(
  colorScheme: brightness == Brightness.dark
      ? _darkColorScheme
      : _lightColorScheme,
  fontFamily: GoogleFonts.cabin().fontFamily,
);

/// The app's localization delegates, shared with widget tests.
///
/// Not `AppLocalizations.localizationsDelegates`: gen-l10n lists the
/// in-framework (package:flutter_localizations) Material/Cupertino delegates,
/// which material_ui widgets don't read. material_ui ships its own.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
  FormBuilderLocalizations.delegate,
  PhoneFieldLocalization.delegate,
  // The sign-in screen (supabase_auth_ui only ships English).
  AuthUILocalizations.delegate,
];

const appSupportedLocales = AppLocalizations.supportedLocales;

class ParApp extends StatelessWidget {
  const ParApp({required this.router, required this.settings, super.key});

  final GoRouter router;
  final SettingsRepository settings;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settings,
    builder: (context, _) => MaterialApp.router(
      title: 'GRUP',
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: appSupportedLocales,
      themeMode: settings.themeMode,
      locale: settings.locale,
      darkTheme: appTheme(Brightness.dark),
      theme: appTheme(Brightness.light),
      routerConfig: router,
    ),
  );
}
