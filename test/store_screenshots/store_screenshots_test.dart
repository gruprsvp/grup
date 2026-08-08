@Tags(['screenshots'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

// Store-screenshot harness: renders real screens with staged demo data at
// store resolutions and captures one PNG per screen × locale × device profile.
// Raw captures land in test/store_screenshots/raw/; compositing them into
// framed, captioned store images is a separate step (see docs/STORE_SCREENSHOTS.md).
//
// Generate with:
//   STORE_SCREENSHOTS=true flutter test --tags screenshots --update-goldens
//
// Gated behind the env var so a plain `flutter test` (CI) never runs or
// compares these goldens.

typedef _Profile = ({Size logical, double dpr});

const _profiles = <String, _Profile>{
  // 1290×2796 — App Store 6.7" (also accepted for 6.9" listings)
  'appstore-6.7': (logical: Size(430, 932), dpr: 3.0),
  // 2160×3840 — matches the current Play 9:16 screenshots
  'play-phone': (logical: Size(432, 768), dpr: 5.0),
};

final _demoProfile = Profile(id: 'demo', displayName: 'Alex');

final _demoGroups = [
  Group(id: '1', displayName: 'Famiglia', description: 'Sunday lunches & more'),
  Group(id: '2', displayName: 'Saturday Football ⚽'),
  Group(id: '3', displayName: 'Book Club', description: 'One book a month'),
  Group(id: '4', displayName: 'D&D Night 🎲'),
];

/// Mirrors the ParApp theme (lib/app.dart) minus google_fonts, which cannot
/// download in tests — bundle Cabin/Sniglet as assets to make captures
/// pixel-identical to production.
ThemeData _appTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF34558B),
    secondary: const Color(0xFF00A4B8),
    tertiary: const Color(0xFF8BE585),
  ),
);

Widget _wrap(Widget screen, Locale locale) => MaterialApp(
  debugShowCheckedModeBanner: false,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: locale,
  theme: _appTheme(),
  home: screen,
);

/// Load real Roboto + MaterialIcons from the Flutter SDK cache so captures
/// don't use the blocky test font. (Cabin/Sniglet still need bundling as
/// assets to be pixel-true — see docs/STORE_SCREENSHOTS.md.)
Future<void> _loadRealFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  if (!dir.existsSync()) return;
  final loaders = <String, FontLoader>{};
  for (final file in dir.listSync().whereType<File>()) {
    final name = file.uri.pathSegments.last;
    final family = switch (name) {
      _ when name.startsWith('Roboto-') => 'Roboto',
      _ when name.startsWith('MaterialIcons') => 'MaterialIcons',
      _ => null,
    };
    if (family == null) continue;
    final bytes = file.readAsBytesSync();
    (loaders[family] ??= FontLoader(family))
        .addFont(Future.value(bytes.buffer.asByteData()));
  }
  await Future.wait(loaders.values.map((l) => l.load()));
}

void main() {
  final enabled = Platform.environment['STORE_SCREENSHOTS'] == 'true';
  setUpAll(_loadRealFonts);

  // One entry per store screenshot: name -> screen under test with demo data.
  final screens = <String, Widget>{
    'home': HomeScreen(profile: _demoProfile, groups: _demoGroups),
  };

  group('store screenshots', skip: enabled ? false : 'STORE_SCREENSHOTS not set', () {
    for (final MapEntry(key: profileName, value: profile) in _profiles.entries) {
      for (final locale in AppLocalizations.supportedLocales) {
        for (final MapEntry(key: screenName, value: screen) in screens.entries) {
          testWidgets('$profileName $locale $screenName', (tester) async {
            tester.view.physicalSize = profile.logical * profile.dpr;
            tester.view.devicePixelRatio = profile.dpr;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(_wrap(screen, locale));
            await tester.pumpAndSettle();

            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile('raw/$profileName/$locale/$screenName.png'),
            );
          });
        }
      }
    }
  });
}
