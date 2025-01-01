import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:styled_text/styled_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
      collapsedTextColor: colorScheme.onSurface,
      collapsedBackgroundColor: colorScheme.surfaceContainer,
      textColor: colorScheme.onSecondaryContainer,
      backgroundColor: colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          l10n.feedbackPromptTitle,
          style: GoogleFonts.sniglet(fontSize: 24),
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
              const _EmailButton(),
              const _StoreButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final emailAddress = 'hello@grup.rsvp';

    final mailtoLink = Mailto(
      to: [emailAddress],
      subject: l10n.feedbackEmailSubject,
      body: l10n.feedbackEmailBody,
    ).toString();

    return FutureBuilder(
      future: canLaunchUrlString(mailtoLink),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return FilledButton.tonalIcon(
            icon: FaIcon(FontAwesomeIcons.envelope),
            label: Text(l10n.feedbackTellUs),
            onPressed: () => launchUrlString(mailtoLink),
          );
        } else {
          // Even if the user can't send an email, show the button
          // with the email address so they can copy it.
          return OutlinedButton.icon(
            icon: FaIcon(FontAwesomeIcons.copy),
            label: Text(emailAddress),
            onPressed: () => _copyToClipboard(context, emailAddress),
          );
        }
      },
    );
  }

  _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton({super.key});

  @override
  Widget build(BuildContext context) {
    // For now show nothing on the web
    if (kIsWeb) return const SizedBox.shrink();

    final storeName = Platform.isIOS
        ? 'App Store'
        : Platform.isAndroid
            ? 'Google Play'
            : null;

    // If the platform is not supported, show nothing
    if (storeName == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inAppReview = InAppReview.instance;

    // From App Store Connect under General > App Information > Apple ID
    final appStoreId = '6473851276';

    return FilledButton.icon(
      style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(colorScheme.onSecondaryContainer)),
      icon: FaIcon(FontAwesomeIcons.solidHeart, color: colorScheme.error),
      label: Text(l10n.feedbackStoreReview(storeName)),
      onPressed: () => inAppReview.openStoreListing(appStoreId: appStoreId),
    );
  }
}
