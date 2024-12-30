import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_text/styled_text.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      collapsedBackgroundColor: colorScheme.surfaceContainer,
      backgroundColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l10n.feedbackPromptTitle,
        style: GoogleFonts.sniglet(
          color: colorScheme.onSecondaryContainer,
          textStyle: textTheme.headlineMedium,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: StyledText(
            text: l10n.feedbackPromptBody,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
            tags: {
              'title': StyledTextTag(
                style: GoogleFonts.sniglet(
                    color: colorScheme.primary),
              ),
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: Text(l10n.feedbackTellUs),
              ),
              FilledButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      colorScheme.onSecondaryContainer),
                ),
                icon: Icon(
                  Icons.favorite,
                  color: colorScheme.error,
                ),
                label:
                Text(l10n.feedbackStoreReview('Google Play')),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
