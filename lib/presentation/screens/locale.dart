import 'package:flutter/material.dart';
import 'package:parousia/l10n/app_localizations.dart';

class LocaleScreen extends StatelessWidget {
  final Locale? selectedLocale;
  final ValueChanged<Locale?> onLocaleChanged;

  // TODO replace with something more robust
  // https://pub.dev/packages/flutter_localized_locales
  static const localeNames = {
    'de': 'Deutsch',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'it': 'Italiano',
  };

  const LocaleScreen({
    super.key,
    this.selectedLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final radioButtons = AppLocalizations.supportedLocales.map(
      (l) => RadioListTile<Locale?>.adaptive(
        title: Text(localeNames[l.languageCode] ?? l.languageCode),
        value: l,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: RadioGroup<Locale?>(
        groupValue: selectedLocale,
        onChanged: onLocaleChanged,
        child: ListView(
          children: [
            RadioListTile<Locale?>.adaptive(
              title: Text(l10n.systemLanguage),
              value: null,
            ),
            ...radioButtons,
          ],
        ),
      ),
    );
  }
}
