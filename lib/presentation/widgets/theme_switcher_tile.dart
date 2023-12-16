import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A ListTile that shows the current theme mode and allows the user to change it.
class ThemeSwitcherTile extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function() onTap;

  const ThemeSwitcherTile({
    super.key,
    nextTheme,
    required this.themeMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (icon, subtitle) = switch (themeMode) {
      ThemeMode.system => (Icons.brightness_auto, l10n.themeSystem),
      ThemeMode.light => (Icons.sunny, l10n.themeLight),
      ThemeMode.dark => (Icons.dark_mode, l10n.themeDark),
    };

    return ListTile(
      title: Text(l10n.changeTheme),
      subtitle: Text(subtitle),
      leading: Icon(icon),
      onTap: onTap,
    );
  }
}
