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
    required this.analytics,
    required this.onAnalyticsChanged,
    this.onSignOut,
  });

  final ThemeMode themeMode;
  final VoidCallback onThemeTap;
  final bool analytics;
  final ValueChanged<bool> onAnalyticsChanged;
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
          SwitchListTile(
            secondary: const Icon(Icons.insights_outlined),
            title: Text(l10n.analyticsSetting),
            subtitle: Text(l10n.analyticsSettingSubtitle),
            value: analytics,
            onChanged: onAnalyticsChanged,
          ),
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
