// The app end to end, on the in-memory backend: real widgets, view models,
// repositories and routing.
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' show ClientException;
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
  setUpAll(initFakeSupabase);

  late FakeBackend backend;
  late GoRouter router;

  Future<void> pumpApp(WidgetTester tester) async {
    final (fake, repositories) = await fakeApp(
      seed: (backend) {
        backend.addProfile('me', name: 'Me');
        final club = backend.addGroup('Club');
        backend.addSchedule(club.id, name: 'Dinner');
      },
    );
    backend = fake;
    router = createRouter(repositories.auth);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: repositories.providers,
        child: ParApp(router: router, settings: repositories.settings),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('answer an event, and see a failed answer undone', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Club'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailsScreen), findsOneWidget);
    expect(find.text('Dinner'), findsOneWidget);

    await tester.tap(find.byTooltip('Yes'));
    await tester.pumpAndSettle();
    expect(backend.replies.values.single.selectedOption, ReplyOptions.yes);

    backend.failure = ClientException('offline');
    await tester.tap(find.byTooltip('No'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining("Couldn't reach GRUP"), findsOneWidget);
    expect(backend.replies.values.single.selectedOption, ReplyOptions.yes);
    // The "yes" is back: its button shows the active (solid) icon again.
    // Solid and regular share code points: the font family tells them apart.
    Finder icon(FaIconData data) =>
        find.byWidgetPredicate((w) => w is FaIcon && w.icon == data.data);
    expect(icon(FontAwesomeIcons.solidThumbsUp), findsOneWidget);
    expect(icon(FontAwesomeIcons.solidThumbsDown), findsNothing);
  });

  testWidgets('the address bar follows the group pages', (tester) async {
    await pumpApp(tester);
    // What go_router reports to the browser: on the web, a refresh or a
    // shared link opens this page.
    String address() => router.routeInformationProvider.value.uri.toString();
    final club = backend.groups.values.single.id;
    final dinner = backend.schedules.values.single.id;

    await tester.tap(find.text('Club'));
    await tester.pumpAndSettle();
    expect(address(), '/groups/$club');

    await tester.tap(find.text('Dinner'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupScheduleDetailsScreen), findsOneWidget);
    expect(Uri.parse(address()).path, '/groups/$club/schedules/$dinner');

    // Back retraces the same pages. go_router keeps the event's ?at= on the
    // way back; the pages below have no such parameter and ignore it.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailsScreen), findsOneWidget);
    expect(Uri.parse(address()).path, '/groups/$club');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(Uri.parse(address()).path, '/');
  });

  testWidgets('signing out shows the sign-in page', (tester) async {
    await pumpApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);

    backend.auth.signIn(null);
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
