import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(l10n.signOut),
      leading: const Icon(Icons.logout),
      onTap: () => _confirmSignOut(context),
    );
  }

  /// Shows a confirmation dialog and signs the user out if confirmed.
  _confirmSignOut(BuildContext context) async {
    final doSignOut = await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          final theme = Theme.of(context);
          final nav = Navigator.of(context);

          return AlertDialog.adaptive(
            icon: const Icon(Icons.logout),
            title: Text(l10n.signOut),
            content: Text(l10n.signOutConfirmation),
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
                child: Text(l10n.signOut),
              ),
            ],
          );
        });

    if (doSignOut == null || !doSignOut) return;

    await Supabase.instance.client.auth.signOut();
    if (!context.mounted) return;
    AuthRoute().replace(context);
  }
}
