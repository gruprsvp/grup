import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';

/// A screen that allows the user to configure app settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onThemeTap,
    this.onSignOut,
  });

  final ThemeMode themeMode;
  final VoidCallback onThemeTap;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.language),
            leading: const Icon(Icons.translate),
            onTap: () => const LocaleRoute().push<void>(context),
          ),
          ThemeSwitcherTile(themeMode: themeMode, onTap: onThemeTap),
          ListTile(
            title: Text(l10n.settingsMoreInfo),
            leading: const Icon(Icons.info_outline),
            onTap: () => const SettingsMoreRoute().push<void>(context),
          ),
          SignOutTile(onSignOut: onSignOut),
        ],
      ),
    );
  }
}
