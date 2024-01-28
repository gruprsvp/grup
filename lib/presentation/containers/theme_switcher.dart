import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/actions/actions.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

part 'theme_switcher.freezed.dart';

class ThemeSwitcherContainer extends StatelessWidget {
  const ThemeSwitcherContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: _ViewModel.fromStore,
        builder: (context, vm) =>
            ThemeSwitcherTile(themeMode: vm.themeMode, onTap: vm.nextTheme));
  }
}

@freezed
sealed class _ViewModel with _$ViewModel {
  const factory _ViewModel({
    required ThemeMode themeMode,
    required VoidCallback nextTheme,
  }) = __ViewModel;

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      themeMode: themeModeSelector(store.state),
      nextTheme: () => store.dispatch(NextThemeAction()),
    );
  }
}
