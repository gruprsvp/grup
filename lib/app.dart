import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/router.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

part 'app.freezed.dart';

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
          ColorScheme lightColorScheme = ColorScheme.fromSeed(
            seedColor: Color(0xFF34558B),
            secondary: Color(0xFF00A4B8),
            tertiary: Color(0xFF8BE585),
          );

          ColorScheme darkColorScheme = ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Color(0xFF93920B),
            secondary: Color(0xFF00623F),
            tertiary: Color(0xFF257F1F),
          );

          // Light theme colors for reference
          Color(0xFF34558B);
          Color(0xFF007DAF);
          Color(0xFF00A4B8);
          Color(0xFF00C8A5);
          Color(0xFF8BE585);
          Color(0xFFF9F871);

          return MaterialApp.router(
            title: 'Grup',
            localizationsDelegates: const [
              ...AppLocalizations.localizationsDelegates,
              FormBuilderLocalizations.delegate,
              SupabaseAuthUILocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: vm.themeMode,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              fontFamily: GoogleFonts.cabin().fontFamily,
            ),
            theme: ThemeData(
              // TODO(borgoat): dynamic color scheme using dynamic_color package
              colorScheme: lightColorScheme,
              fontFamily: GoogleFonts.cabin().fontFamily,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ThemeMode themeMode,
    Locale? locale,
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      locale: localeSelector(store.state),
    );
  }
}
