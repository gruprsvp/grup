import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// The terms of service to accept before using the app.
class TermsScreen extends StatelessWidget {
  const TermsScreen({
    super.key,
    required this.busy,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
    required this.onAccept,
    required this.onSignOut,
  });

  final bool busy;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;
  final VoidCallback onAccept;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.termsTitle,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(l10n.termsBody, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: onOpenTerms,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.termsOfService),
                ),
                TextButton.icon(
                  onPressed: onOpenPrivacy,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.privacyPolicy),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: busy ? null : onAccept,
                  child: Text(l10n.termsAccept),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: busy ? null : onSignOut,
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
