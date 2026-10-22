import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';

/// Screen for less common settings.
class SettingsMoreScreen extends StatelessWidget {
  const SettingsMoreScreen({super.key, this.onDeleteProfile});

  final VoidCallback? onDeleteProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsMoreInfo)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.licenses),
            leading: const Icon(Icons.copyright),
            onTap: () => const LicensesRoute().push(context),
          ),
          DeleteProfileTile(onDelete: onDeleteProfile),
        ],
      ),
    );
  }
}
