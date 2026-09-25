import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
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
          locales: appSupportedLocales,
          localizationsDelegates: appLocalizationsDelegates,
          initialLocale: const Locale('en'),
        ),
        // Use cases are app widgets built on package:material_ui, while
        // Widgetbook's own shell is framework Material. MaterialThemeAddon
        // would only set a framework Theme, so give each use case the app's
        // material_ui theme and a Material surface (text fields need one).
        ThemeAddon<ThemeData>(
          themes: [
            WidgetbookTheme(name: 'Light', data: appTheme(Brightness.light)),
            WidgetbookTheme(name: 'Dark', data: appTheme(Brightness.dark)),
          ],
          themeBuilder: (context, theme, child) => Theme(
            data: theme,
            child: Material(child: child),
          ),
        ),
        InspectorAddon(),
      ],
    );
  }
}
