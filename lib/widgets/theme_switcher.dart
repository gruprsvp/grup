import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/blocs/blocs.dart';

/// ListTile to switch between light, dark and system theme.
class ThemeSwitcher extends StatelessWidget {
  /// Creates a [ThemeSwitcher].
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        final (icon, subtitle) = switch (state) {
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
          onTap: () => context.read<ThemeCubit>().nextTheme(),
        );
      },
    );
  }
}
