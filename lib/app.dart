import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/router.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'app.freezed.dart';

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
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  ...AppLocalizations.localizationsDelegates,
  FormBuilderLocalizations.delegate,
  // NOTE: upstream supabase_auth_ui (0.6.1) has no unified localizations
  // delegate; auth-component strings are localized per-component instead.
  // The forked package's SupabaseAuthUILocalizations was dropped in the
  // migration. TODO: re-base the custom auth translations (en/fr/de/es/it).
];

const appSupportedLocales = AppLocalizations.supportedLocales;

class ParApp extends StatelessWidget {
  const ParApp({required this.store, super.key});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: _ViewModel.fromStore,
        onInit: store.dispatch(AppStartedAction()),
        builder: (context, vm) {
          return MaterialApp.router(
            title: 'GRUP',
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: appSupportedLocales,
            themeMode: vm.themeMode,
            locale: vm.locale,
            darkTheme: appTheme(Brightness.dark),
            theme: appTheme(Brightness.light),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({required ThemeMode themeMode, Locale? locale}) =
      __ViewModel;

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      locale: localeSelector(store.state),
    );
  }
}
