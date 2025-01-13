import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mailto/mailto.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  final _emailAddress = 'hello@grup.rsvp';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FilledButton.tonalIcon(
      icon: FaIcon(FontAwesomeIcons.envelope),
      label: Text(l10n.feedbackTellUs),
      onPressed: () => _attemptOpenEmail(context),
    );
  }

  /// Try to open the user's email app with the prefilled email.
  /// If it fails, copy the email address to the clipboard and show a snackbar.
  Future<void> _attemptOpenEmail(BuildContext context) async {
    final url = await _prepareEmailUrl(context);

    try {
      await launchUrlString(url);
    } catch (e) {
      if (!context.mounted) return;
      return _failedToOpenEmail(context);
    }
  }

  Future<void> _failedToOpenEmail(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.feedbackEmailCantSend(_emailAddress)),
        action: SnackBarAction(
            label: l10n.copy, onPressed: () => _copyToClipboard(context)),
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: _emailAddress));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
    );
  }

  /// Get the app version and device info to include in the email.
  /// Then, prepare the email URL with the prefilled body.
  /// We no longer check if the app can launch since it can fail even if it can.
  /// see https://github.com/flutter/flutter/issues/157828
  /// If it fails, we copy the email address to the clipboard instead.
  Future<String> _prepareEmailUrl(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    final (versionString, deviceString) =
        await (_getVersionString(), _getDeviceString()).wait;

    final info = '''


---
$versionString
$deviceString
''';

    final body = l10n.feedbackEmailBody + info;

    final mailtoLink = Mailto(
      to: [_emailAddress],
      subject: l10n.feedbackEmailSubject,
      body: body,
    ).toString();

    return mailtoLink;
  }

  Future<String> _getVersionString() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return 'Version: ${packageInfo.version}+${packageInfo.buildNumber}';
  }

  Future<String> _getDeviceString() async {
    final diPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      final info = await diPlugin.webBrowserInfo;
      return 'Browser: ${info.browserName.name} (${info.userAgent})';
    } else {
      if (Platform.isAndroid) {
        final info = await diPlugin.androidInfo;
        return 'Android ${info.version.release} (${info.manufacturer} ${info.model})';
      } else if (Platform.isIOS) {
        final info = await diPlugin.iosInfo;
        return '${info.systemName} ${info.systemVersion} (${info.modelName})';
      } else {
        return 'Unknown device';
      }
    }
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
