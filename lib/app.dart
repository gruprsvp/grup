import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/router.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

part 'app.freezed.dart';

class ParApp extends StatefulWidget {
  const ParApp({required this.store, super.key});

  final Store<AppState> store;

  @override
  State<ParApp> createState() => _ParAppState();
}

class _ParAppState extends State<ParApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

    // Delegate deeplinks to the store
    final appLinks = AppLinks();
    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      widget.store.dispatch(HandleDeeplinkAction(uri.path));
    });
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: widget.store,
      child: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: _ViewModel.fromStore,
        onInit: widget.store.dispatch(AppStartedAction()),
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
              title: 'AppFor.it',
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
              ),
              theme: ThemeData(
                // TODO(borgoat): dynamic color scheme using dynamic_color package
                colorScheme: lightColorScheme,
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
