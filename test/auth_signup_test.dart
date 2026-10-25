// A separate file from auth_screen_test.dart: Supabase is a singleton, and
// this one answers sign-up the way a project with email confirmations does.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/presentation/screens/auth.dart';

import 'support/fake_supabase.dart';

void main() {
  setUpAll(
    () => initFakeSupabase(
      // GoTrue with confirmations on: the new user, and no session.
      httpClient: MockClient(
        (request) async => http.Response(
          jsonEncode({
            'id': '00000000-0000-0000-0000-000000000001',
            'aud': 'authenticated',
            'email': 'new@example.com',
            'app_metadata': <String, Object>{},
            'user_metadata': <String, Object>{},
            'created_at': '2026-10-25T12:00:00Z',
            'confirmation_sent_at': '2026-10-25T12:00:00Z',
          }),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    ),
  );

  testWidgets('a sign-up waiting for its email says to open the link', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: appTheme(Brightness.light),
        localizationsDelegates: appLocalizationsDelegates,
        supportedLocales: appSupportedLocales,
        home: const AuthScreen(),
      ),
    );
    await tester.pump();

    await tester.tap(find.text("Don't have an account? Sign up"));
    await tester.pump();
    await tester.enterText(find.byType(EditableText).at(0), 'new@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'password');
    await tester.tap(find.text('Sign Up'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(tester.takeException(), isNull);
    expect(find.textContaining('open the link we emailed you'), findsOneWidget);
  });
}
