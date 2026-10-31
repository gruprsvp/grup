// go_router picks its page type by looking for a MaterialApp ancestor. Since
// Flutter 3.47 there are two MaterialApp types (package:flutter/material.dart
// and package:material_ui); if go_router looks for the one the app doesn't
// use, it silently falls back to NoTransitionPage and every page transition
// disappears. Nothing else in CI would notice.
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/router.dart';
import 'package:provider/provider.dart';

import 'support/fake_backend.dart';
import 'support/fake_supabase.dart';
import 'support/harness.dart';

void main() {
  group('redirect', () {
    String? signedOut(String location) => redirect(Uri.parse(location), false);
    String? signedIn(String location) => redirect(Uri.parse(location), true);

    test('sends signed-out users to sign in, then back', () {
      expect(signedOut('/'), '/auth');
      expect(signedOut('/join/ABCD-1234'), '/auth?from=%2Fjoin%2FABCD-1234');
      expect(signedOut('/auth'), isNull);

      expect(signedIn('/auth?from=%2Fjoin%2FABCD-1234'), '/join/ABCD-1234');
      expect(signedIn('/auth'), '/');
      expect(signedIn('/groups/1'), isNull);
    });

    test('never redirects outside the app after sign-in', () {
      expect(signedIn('/auth?from=https%3A%2F%2Fevil.example'), '/');
      expect(signedIn('/auth?from=%2F%2Fevil.example'), '/');
    });

    test('a return from an outside page (Stripe) opens its local path', () {
      const back = '/?return=%2Fgroups%2F1%2Fplan%3Fcheckout%3Dsuccess';
      expect(signedIn(back), '/groups/1/plan?checkout=success');
      expect(signedIn('/?return=%2F%2Fevil.example'), '/');
      expect(signedIn('/?return=https%3A%2F%2Fevil.example'), '/');
      // Only the root returns: the web host serves nothing else.
      expect(signedIn('/groups/1?return=%2Fsettings'), isNull);

      // Signed out: through sign-in, then on to the page.
      final auth = signedOut(back)!;
      expect(Uri.parse(auth).path, '/auth');
      final from = signedIn(auth)!;
      expect(from, '/?return=%2Fgroups%2F1%2Fplan%3Fcheckout%3Dsuccess');
      expect(signedIn(from), '/groups/1/plan?checkout=success');
    });

    test('opens app links at their path; other schemes go home', () {
      expect(
        signedIn('https://grup.rsvp/join/ABCD-1234?x=1'),
        '/join/ABCD-1234?x=1',
      );
      expect(signedIn('https://grup.rsvp'), '/');
      expect(signedIn('grup://auth-callback?code=secret'), '/');
    });
  });

  group('the app', () {
    setUpAll(initFakeSupabase);

    Future<FakeBackend> pumpApp(
      WidgetTester tester,
      String location, {
      ValueNotifier<bool>? updateRequired,
    }) async {
      final (backend, repositories) = await fakeApp(userId: null);
      final router = createRouter(repositories.auth)..go(location);
      addTearDown(router.dispose);
      await tester.pumpWidget(
        MultiProvider(
          providers: repositories.providers,
          child: ParApp(
            router: router,
            settings: repositories.settings,
            updateRequired: updateRequired,
          ),
        ),
      );
      await tester.pumpAndSettle();
      return backend;
    }

    testWidgets('an unsupported version shows only the update screen', (
      tester,
    ) async {
      final updateRequired = ValueNotifier(false);
      await pumpApp(tester, '/join/ABCD-1234', updateRequired: updateRequired);
      expect(find.byType(AuthScreen), findsOneWidget);

      updateRequired.value = true;
      await tester.pumpAndSettle();

      expect(find.byType(UpdateRequiredScreen), findsOneWidget);
      expect(find.byType(AuthScreen), findsNothing);
    });

    testWidgets('routes are built as MaterialPage', (tester) async {
      await pumpApp(tester, '/');

      // Signed out, so the redirect lands on the auth screen.
      expect(find.byType(AuthScreen), findsOneWidget);
      final navigator = tester.widget<Navigator>(find.byType(Navigator).first);
      expect(navigator.pages, isNotEmpty);
      for (final page in navigator.pages) {
        expect(
          page.runtimeType.toString(),
          startsWith('MaterialPage'),
          reason: 'go_router did not detect the MaterialApp',
        );
      }
    });

    testWidgets('an invite link survives signing in', (tester) async {
      final backend = await pumpApp(tester, '/join/CODE-1');
      expect(find.byType(AuthScreen), findsOneWidget);

      // Someone else's group, with an invite code for a new member.
      backend.userId = 'admin';
      final club = backend.addGroup('Club');
      final slot = backend.addMember(club.id, name: 'Invitee');
      await backend.invitesService.inviteMember(
        slot.id,
        InviteMethods.code,
        'CODE-1',
      );
      backend.userId = null;

      backend.addProfile('me', name: 'Me');
      backend.auth.signIn('me');
      await tester.pumpAndSettle();

      // Back from sign-in to the link, which joined the group.
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Club'), findsOneWidget);
    });

    testWidgets('an unknown address shows not found, also after sign-in', (
      tester,
    ) async {
      final backend = await pumpApp(tester, '/no/such/page');
      expect(find.byType(AuthScreen), findsOneWidget);

      backend.addProfile('me', name: 'Me');
      backend.auth.signIn('me');
      await tester.pumpAndSettle();
      expect(find.byType(NotFoundScreen), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
