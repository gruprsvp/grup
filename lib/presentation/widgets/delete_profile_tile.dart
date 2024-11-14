import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:parousia/actions/profiles.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/state/state.dart';

/// A ListTile that deletes the user profile when tapped,
/// with an adaptive confirmation dialog.
class DeleteProfileTile extends StatelessWidget {
  const DeleteProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text("Delete profile"),
      leading: const Icon(Icons.delete),
      onTap: () => _confirmDelete(context),
    );
  }

  /// Shows a confirmation dialog and deletes the user profile if confirmed.
  _confirmDelete(BuildContext context) async {
    final doDelete = await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          final theme = Theme.of(context);
          final nav = Navigator.of(context);

          return AlertDialog.adaptive(
            icon: const Icon(Icons.logout),
            title: Text("Delete profile"),
            content: Text("Are you sure you want to delete your profile?"),
            actions: [
              TextButton(
                onPressed: () => nav.pop(false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => nav.pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                child: Text("Delete"),
              ),
            ],
          );
        });

    if (doDelete == null || !doDelete) return;

    //await Supabase.instance.client.auth.signOut();
    if (!context.mounted) return;
    StoreProvider.of<AppState>(context).dispatch(const DeleteProfileAction());
    AuthRoute().replace(context);
  }
}
