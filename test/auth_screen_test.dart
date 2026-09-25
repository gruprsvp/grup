// Guards the auth screen, whose supabase_auth_ui widgets are the app's main
// consumer of Material through a third-party package. They look up Theme,
// MaterialLocalizations, a Material ancestor and a ScaffoldMessenger (for the
// error SnackBar). If any of those lookups stops resolving, framework
// assertions fire here, and a failed sign-in no longer shows an error.
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/app.dart';
import 'package:parousia/presentation/screens/auth.dart';

import 'support/fake_supabase.dart';

void main() {
  setUpAll(initFakeSupabase);

  Widget wrap(Widget child) => MaterialApp(
    theme: appTheme(Brightness.light),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: appSupportedLocales,
    home: child,
  );

  testWidgets('auth screen renders without framework assertions', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const AuthScreen()));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(EditableText), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
  });

  testWidgets('auth fields use the app theme', (tester) async {
    await tester.pumpWidget(wrap(const AuthScreen()));
    await tester.pump();

    final cursorColor = tester
        .widget<EditableText>(find.byType(EditableText).first)
        .cursorColor;
    expect(cursorColor, appTheme(Brightness.light).colorScheme.primary);
  });

  testWidgets('a failed sign-in shows an error SnackBar', (tester) async {
    await tester.pumpWidget(wrap(const AuthScreen()));
    await tester.pump();

    await tester.enterText(find.byType(EditableText).at(0), 'a@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'wrong-password');
    await tester.tap(find.text('Sign In'));

    // Let the real (not fake-async) HTTP future complete, then settle.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    // Matched by runtime type name so the finder works whichever Material
    // library the SnackBar comes from.
    expect(
      find.byWidgetPredicate((w) => w.runtimeType.toString() == 'SnackBar'),
      findsOneWidget,
    );
  });
}
