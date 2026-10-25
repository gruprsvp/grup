import 'package:flutter/foundation.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/l10n/auth_ui_localizations.dart';
import 'package:parousia/presentation/presentation.dart';
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
ThemeData appTheme(Brightness brightness) {
  final colorScheme = brightness == Brightness.dark
      ? _darkColorScheme
      : _lightColorScheme;
  return ThemeData(
    colorScheme: colorScheme,
    fontFamily: GoogleFonts.cabin().fontFamily,
    inputDecorationTheme: appInputDecorationTheme(colorScheme),
    // Cards are what you act on (a group, an event): lifted, softly rounded.
    cardTheme: const CardThemeData(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(64, 48)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
    tabBarTheme: const TabBarThemeData(dividerHeight: 0),
  );
}

/// Filled, rounded text fields with no underline. Also mirrored onto the
/// sign-in screen's framework theme (`screens/auth.dart`).
InputDecorationTheme appInputDecorationTheme(ColorScheme colorScheme) {
  UnderlineInputBorder border([Color? color]) => UnderlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    borderSide: color == null
        ? BorderSide.none
        : BorderSide(color: color, width: 2),
  );
  return InputDecorationTheme(
    filled: true,
    fillColor: colorScheme.surfaceContainerHighest,
    border: border(),
    enabledBorder: border(),
    focusedBorder: border(colorScheme.primary),
    errorBorder: border(colorScheme.error),
    focusedErrorBorder: border(colorScheme.error),
  );
}

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
  const ParApp({
    required this.router,
    required this.settings,
    this.updateRequired,
    super.key,
  });

  final GoRouter router;
  final SettingsRepository settings;

  /// When true, every page gives way to [UpdateRequiredScreen].
  final ValueListenable<bool>? updateRequired;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([settings, ?updateRequired]),
    builder: (context, _) => MaterialApp.router(
      title: 'GRUP',
      localizationsDelegates: appLocalizationsDelegates,
      supportedLocales: appSupportedLocales,
      themeMode: settings.themeMode,
      locale: settings.locale,
      darkTheme: appTheme(Brightness.dark),
      theme: appTheme(Brightness.light),
      routerConfig: router,
      builder: (context, child) => updateRequired?.value ?? false
          ? UpdateRequiredScreen(
              onUpdate: () =>
                  InAppReview.instance.openStoreListing(appStoreId: appStoreId),
            )
          : child!,
    ),
  );
}
