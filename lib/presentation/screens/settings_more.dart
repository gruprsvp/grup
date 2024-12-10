import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';

/// Screen for less common settings.
class SettingsMoreScreen extends StatelessWidget {
  const SettingsMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsMoreInfo),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Licenses'),
            leading: const Icon(Icons.copyright),
            onTap: () => LicensesRoute().push(context),
          ),
          const DeleteProfileTile(),
        ],
      ),
    );
  }
}
