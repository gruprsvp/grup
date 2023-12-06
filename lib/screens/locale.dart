import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleScreen extends StatelessWidget {
  final Locale? selectedLocale;
  final void Function(Locale?) changeLocale;

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
    required this.changeLocale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final radioButtons = AppLocalizations.supportedLocales.map(
      (l) => RadioListTile<Locale>.adaptive(
        title: Text(localeNames[l.languageCode] ?? l.languageCode),
        groupValue: selectedLocale,
        value: l,
        onChanged: (l) => changeLocale(l!),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
      ),
      body: Column(
        children: [
          RadioListTile.adaptive(
            title: Text(l10n.systemLanguage),
            groupValue: selectedLocale,
            value: null,
            onChanged: (l) => changeLocale(null),
          ),
          ...radioButtons,
        ],
      ),
    );
  }
}
