import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// Replaces the whole app when this version is no longer supported.
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key, required this.onUpdate});

  /// Opens the app's store page.
  final VoidCallback onUpdate;

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
                  l10n.updateRequiredTitle,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(l10n.updateRequiredBody, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: onUpdate,
                  child: Text(l10n.updateRequiredAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
