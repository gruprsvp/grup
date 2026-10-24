import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// Shown for an address that matches no page.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.onHome});

  /// Opens the home page.
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.notFoundTitle,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(l10n.notFoundBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onHome,
                  child: Text(l10n.notFoundAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
