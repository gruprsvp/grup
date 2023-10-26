import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/screens/screens.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'app.freezed.dart';

final _routerConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

/// The app entry-point
class ParApp extends StatelessWidget {
  /// Creates a [ParApp].
  const ParApp({super.key, required this.store});

  final Store<RootState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreConnector<RootState, _ViewModel>(
        distinct: true,
        converter: _ViewModel.fromStore,
        builder: (context, vm) => MaterialApp.router(
          title: 'Parousia',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          themeMode: vm.themeMode,
          darkTheme: ThemeData.dark(useMaterial3: true),
          theme: ThemeData(
            // TODO(borgoat): dynamic color scheme using dynamic_color package
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          routerConfig: _routerConfig,
        ),
      ),
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ThemeMode themeMode,
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<RootState> store) {
    return _ViewModel(themeMode: themeModeSelector(store.state));
  }
}
