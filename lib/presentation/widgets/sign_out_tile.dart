import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// A ListTile that signs the user out when tapped,
/// with an adaptive confirmation dialog.
class SignOutTile extends StatelessWidget {
  const SignOutTile({super.key, required this.onSignOut});

  /// Signing out sends the user to the sign-in page (see router.dart).
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(l10n.signOut),
      leading: const Icon(Icons.logout),
      onTap: onSignOut == null ? null : () => _confirmSignOut(context),
    );
  }

  /// Shows a confirmation dialog and signs the user out if confirmed.
  Future<void> _confirmSignOut(BuildContext context) async {
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
      },
    );

    if (doSignOut == true) onSignOut?.call();
  }
}
