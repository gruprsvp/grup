import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/router.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'app.freezed.dart';

class ParApp extends StatelessWidget {
  const ParApp({required this.store, super.key});

  final Store<RootState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreConnector<RootState, _ViewModel>(
        distinct: true,
        converter: _ViewModel.fromStore,
        builder: (context, vm) => DynamicColorBuilder(
          builder: (lightDynamic, darkDynamic) {
            // TODO Take something from state
            const overrideColour = null;
            const defaultColour = Colors.orange;

            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized().copyWith(
                    secondary: overrideColour,
                  );
              darkColorScheme = darkDynamic.harmonized().copyWith(
                    secondary: overrideColour,
                  );
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: overrideColour ?? defaultColour,
              );
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: overrideColour ?? defaultColour,
                brightness: Brightness.dark,
              );
            }

            return MaterialApp.router(
              title: 'Parousia',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: vm.themeMode,
              locale: vm.locale,
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                useMaterial3: true,
              ),
              theme: ThemeData(
                // TODO(borgoat): dynamic color scheme using dynamic_color package
                colorScheme: lightColorScheme,
                useMaterial3: true,
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
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<RootState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      locale: localeSelector(store.state),
    );
  }
}
