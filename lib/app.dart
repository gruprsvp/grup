import 'package:dynamic_color/dynamic_color.dart';
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
        builder: (context, vm) => DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            final override = vm.overrideColour;
            const defaultColour = Colors.lime;

            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme =
                  lightDynamic.harmonized().copyWith(secondary: override);
              darkColorScheme =
                  darkDynamic.harmonized().copyWith(secondary: override);
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme =
                  ColorScheme.fromSeed(seedColor: override ?? defaultColour);
              darkColorScheme = ColorScheme.fromSeed(
                  seedColor: override ?? defaultColour,
                  brightness: Brightness.dark);
            }

            return MaterialApp.router(
              title: 'Grup',
              localizationsDelegates: const [
                ...AppLocalizations.localizationsDelegates,
                FormBuilderLocalizations.delegate,
                SupabaseAuthUILocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: vm.themeMode,
              locale: vm.locale,
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
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ThemeMode themeMode,
    Locale? locale,
    Color? overrideColour,
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      locale: localeSelector(store.state),
      overrideColour: null, // TODO Where could this come from?
    );
  }
}
