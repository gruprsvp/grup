import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';

/// Asks once whether the user shares usage analytics.
class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key, required this.onChoice});

  final ValueChanged<bool> onChoice;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.analyticsTitle, style: GoogleFonts.sniglet(fontSize: 24)),
            const SizedBox(height: 8),
            Text(l10n.analyticsBody, style: textTheme.bodyLarge),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  onPressed: () => onChoice(false),
                  child: Text(l10n.analyticsNo),
                ),
                FilledButton(
                  onPressed: () => onChoice(true),
                  child: Text(l10n.analyticsYes),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
