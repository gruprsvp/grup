// Form widgets from third-party packages must resolve the app's theme. A
// package built against a different Material library than the app's falls
// back to a default theme without any error, so check a colour that only
// comes from the app theme: the text cursor (ColorScheme.primary).
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:parousia/app.dart';
import 'package:phone_form_field/phone_form_field.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  // Resolved lazily: appTheme() touches google_fonts, which needs the binding.
  Color primary() => appTheme(Brightness.light).colorScheme.primary;

  Widget wrap(Widget child) => MaterialApp(
    theme: appTheme(Brightness.light),
    localizationsDelegates: [
      ...appLocalizationsDelegates,
      ...PhoneFieldLocalization.delegates,
    ],
    supportedLocales: appSupportedLocales,
    home: Scaffold(body: child),
  );

  Color cursorColor(WidgetTester tester) =>
      tester.widget<EditableText>(find.byType(EditableText)).cursorColor;

  testWidgets('FormBuilderTextField uses the app theme', (tester) async {
    await tester.pumpWidget(
      wrap(FormBuilder(child: FormBuilderTextField(name: 'name'))),
    );
    expect(tester.takeException(), isNull);
    expect(cursorColor(tester), primary());
  });

  testWidgets('PhoneFormField uses the app theme', (tester) async {
    await tester.pumpWidget(wrap(PhoneFormField()));
    expect(tester.takeException(), isNull);
    expect(cursorColor(tester), primary());
  });
}
