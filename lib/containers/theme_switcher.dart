import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'theme_switcher.freezed.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<RootState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        final (icon, subtitle) = switch (vm.themeMode) {
          ThemeMode.system => (
              Icons.brightness_auto,
              AppLocalizations.of(context)!.themeSystem,
            ),
          ThemeMode.light => (
              Icons.sunny,
              AppLocalizations.of(context)!.themeLight,
            ),
          ThemeMode.dark => (
              Icons.dark_mode,
              AppLocalizations.of(context)!.themeDark,
            ),
        };

        return ListTile(
          title: Text(AppLocalizations.of(context)!.changeTheme),
          subtitle: Text(subtitle),
          leading: Icon(icon),
          onTap: vm.nextTheme,
        );
      },
    );
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ThemeMode themeMode,
    required void Function() nextTheme,
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<RootState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      nextTheme: () => store.dispatch(NextThemeAction()),
    );
  }
}
