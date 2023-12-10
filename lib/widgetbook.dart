import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'widgetbook.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        AccessibilityAddon(),
        AlignmentAddon(),
        DeviceFrameAddon(devices: Devices.all),
        LocalizationAddon(
          locales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialLocale: const Locale('en'),
        ),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: ThemeData.light()),
            WidgetbookTheme(name: 'Dark', data: ThemeData.dark()),
          ],
        ),
        InspectorAddon(),
      ],
    );
  }
}
