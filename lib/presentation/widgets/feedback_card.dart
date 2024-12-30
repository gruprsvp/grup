import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:styled_text/styled_text.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final storeName = !kIsWeb && Platform.isIOS ? 'App Store' : 'Google Play';

    final inAppReview = InAppReview.instance;

    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      collapsedTextColor: colorScheme.onSurface,
      collapsedBackgroundColor: colorScheme.surfaceContainer,
      textColor: colorScheme.onSecondaryContainer,
      backgroundColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l10n.feedbackPromptTitle,
        style: GoogleFonts.sniglet(fontSize: 24),
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
                style: GoogleFonts.sniglet(color: colorScheme.primary),
              ),
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              FilledButton.tonalIcon(
                icon: FaIcon(FontAwesomeIcons.envelope),
                label: Text(l10n.feedbackTellUs),
                onPressed: () async {
                  final email = Email(
                    recipients: ['hello@grup.rsvp'],
                    subject: l10n.feedbackEmailSubject,
                    body: l10n.feedbackEmailBody,
                  );
                  await FlutterEmailSender.send(email);
                },
              ),
              FilledButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(colorScheme.onSecondaryContainer),
                ),
                icon: FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: colorScheme.error,
                ),
                label: Text(l10n.feedbackStoreReview(storeName)),
                onPressed: () =>
                    inAppReview.openStoreListing(appStoreId: '6473851276'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
