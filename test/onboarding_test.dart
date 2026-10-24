// The first-run surfaces in every language, on a small phone with large text:
// a layout overflow fails the test.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/presentation/presentation.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  /// A 360dp-wide phone, reset after the test.
  void smallPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Widget wrap(Locale locale, Widget child) => MaterialApp(
    theme: appTheme(Brightness.light),
    locale: locale,
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: appSupportedLocales,
    home: Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.3)),
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );

  for (final locale in appSupportedLocales) {
    group('at 360dp and 1.3× text, in ${locale.languageCode}', () {
      testWidgets('the home intro fits', (tester) async {
        smallPhone(tester);
        await tester.pumpWidget(
          wrap(locale, HomeIntro(onCreate: () {}, onJoin: () {})),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('the group setup fits', (tester) async {
        smallPhone(tester);
        await tester.pumpWidget(
          wrap(
            locale,
            GroupSetup(
              hasEvents: true,
              hasMembers: false,
              onAddEvent: () {},
              onInvite: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });
  }
}
