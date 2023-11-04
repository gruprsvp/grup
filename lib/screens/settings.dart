import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/containers/containers.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

/// A screen that allows the user to configure app settings.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          const ThemeSwitcher(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.signOut),
            leading: const Icon(Icons.logout),
            onTap: () {
              // TODO(borgoat): show confirmation dialog and use Redux
              Supabase.instance.client.auth.signOut();
              AuthRoute().replace(context);
            },
          ),
        ],
      ),
    );
  }
}
