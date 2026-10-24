// The app end to end, on the in-memory backend: real widgets, view models,
// repositories and routing.
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' show ClientException;
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/go_router_builder.dart';
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

  Future<void> pumpApp(
    WidgetTester tester, {
    void Function(FakeBackend)? seed,
  }) async {
    final (fake, repositories) = await fakeApp(
      seed:
          seed ??
          (backend) {
            backend.addProfile('me', name: 'Me');
            final club = backend.addGroup('Club');
            backend.addSchedule(club.id, name: 'Dinner');
            backend.addMember(club.id, name: 'Ann');
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

  testWidgets('an admin answering for someone else can undo it', (
    tester,
  ) async {
    await pumpApp(tester);
    final ann = backend.members.values.singleWhere(
      (m) => m.displayNameOverride == 'Ann',
    );

    await tester.tap(find.text('Club'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dinner'));
    await tester.pumpAndSettle();

    final annYes = find.descendant(
      of: find.widgetWithText(ListTile, 'Ann'),
      matching: find.byTooltip('Yes'),
    );
    await tester.ensureVisible(annYes);
    await tester.tap(annYes);
    await tester.pumpAndSettle();
    expect(backend.replies.values.single.memberId, ann.id);
    expect(find.text('Ann marked as coming'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(backend.replies, isEmpty);
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

  group('on a wide window', () {
    void wide(WidgetTester tester, [double width = 1280]) {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Future<void> pumpTwoEvents(WidgetTester tester) => pumpApp(
      tester,
      seed: (backend) {
        backend.addProfile('me', name: 'Me');
        final club = backend.addGroup('Club');
        backend.addSchedule(club.id, name: 'Dinner');
        backend.addSchedule(
          club.id,
          name: 'Drinks',
          start: DateTime.utc(2024, 1, 1, 21),
        );
        backend.addMember(club.id, name: 'Ann');
      },
    );

    String path() => router.routeInformationProvider.value.uri.path;
    Finder inList(String text) => find.descendant(
      of: find.byType(GroupDetailsScreen),
      matching: find.text(text),
    );
    Finder inDetail(String text) => find.descendant(
      of: find.byType(GroupScheduleDetailsScreen),
      matching: find.text(text),
    );
    GroupDetailsViewModel listViewModel(WidgetTester tester) =>
        tester.element(find.byType(GroupDetailsScreen)).read();

    testWidgets("a group's day shows its first event alongside", (
      tester,
    ) async {
      wide(tester);
      await pumpTwoEvents(tester);
      final club = backend.groups.values.single.id;

      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      expect(path(), '/groups/$club');
      expect(inDetail('Dinner'), findsOneWidget);
      // Screen readers hear which event is open.
      final semantics = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.widgetWithText(ScheduleTile, 'Dinner')),
        isSemantics(isSelected: true, hasSelectedState: true),
      );
      semantics.dispose();
      // The event is part of the page: nothing to go back from.
      expect(
        find.descendant(
          of: find.byType(GroupScheduleDetailsScreen),
          matching: find.byType(BackButton),
        ),
        findsNothing,
      );
    });

    testWidgets('opening events keeps the list as it is', (tester) async {
      wide(tester);
      await pumpTwoEvents(tester);
      final club = backend.groups.values.single.id;
      final drinks = backend.schedules.values.last.id;

      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      await tester.tap(inList('Dinner'));
      await tester.pumpAndSettle();
      final list = listViewModel(tester);

      await tester.tap(inList('Drinks'));
      await tester.pumpAndSettle();
      expect(path(), '/groups/$club/schedules/$drinks');
      expect(inDetail('Drinks'), findsOneWidget);
      expect(inDetail('Dinner'), findsNothing);
      expect(identical(listViewModel(tester), list), isTrue);

      // One snackbar, not one per pane.
      final annYes = find.descendant(
        of: find.widgetWithText(ListTile, 'Ann'),
        matching: find.byTooltip('Yes'),
      );
      await tester.ensureVisible(annYes);
      await tester.tap(annYes);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);

      // Back leaves the group, rather than closing the event.
      await tester.tap(
        find.descendant(
          of: find.byType(GroupDetailsScreen),
          matching: find.byType(BackButton),
        ),
      );
      await tester.pumpAndSettle();
      expect(path(), '/');
    });

    testWidgets("a link to another group's event shows that group", (
      tester,
    ) async {
      wide(tester);
      await pumpApp(
        tester,
        seed: (backend) {
          backend.addProfile('me', name: 'Me');
          final club = backend.addGroup('Club');
          backend.addSchedule(club.id, name: 'Dinner');
          final choir = backend.addGroup('Choir');
          backend.addSchedule(choir.id, name: 'Rehearsal');
        },
      );
      final choir = backend.groups.values.last.id;
      final rehearsal = backend.schedules.values.last;

      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      await tester.tap(inList('Dinner'));
      await tester.pumpAndSettle();

      router.go(
        GroupScheduleDetailsRoute(
          groupId: choir,
          scheduleId: rehearsal.id,
          at: DateTime.utc(2024, 1, 1, 18),
        ).location,
      );
      await tester.pumpAndSettle();
      expect(inList('Choir'), findsOneWidget);
      expect(inDetail('Rehearsal'), findsOneWidget);
    });

    testWidgets('narrowing the window shows the event alone', (tester) async {
      wide(tester);
      await pumpTwoEvents(tester);

      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      await tester.tap(inList('Drinks'));
      await tester.pumpAndSettle();

      wide(tester, 700);
      await tester.pumpAndSettle();
      expect(find.byType(GroupDetailsScreen), findsNothing);
      expect(inDetail('Drinks'), findsOneWidget);

      wide(tester);
      await tester.pumpAndSettle();
      expect(inList('Dinner'), findsOneWidget);
      expect(inDetail('Drinks'), findsOneWidget);
    });
  });

  testWidgets('the address bar follows manage and profile', (tester) async {
    await pumpApp(tester);
    String path() => router.routeInformationProvider.value.uri.path;
    final club = backend.groups.values.single.id;

    await tester.tap(find.text('Club'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage group'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupManageScreen), findsOneWidget);
    expect(path(), '/groups/$club/manage');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(path(), '/profile');
  });

  testWidgets('a new user is shown how GRUP works, and starts a group', (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (backend) => backend.addProfile('me', name: 'Me'),
    );

    expect(
      find.text("Know who's coming, without asking around."),
      findsOneWidget,
    );
    // The intro brings its own ways in.
    expect(find.byType(FloatingActionButton), findsNothing);

    final start = find.widgetWithText(FilledButton, 'Start a group');
    await tester.ensureVisible(start);
    await tester.pumpAndSettle();
    await tester.tap(start);
    await tester.pumpAndSettle();
    expect(find.byType(GroupForm), findsOneWidget);
  });

  testWidgets("a new group's admin is shown what's left to set up", (
    tester,
  ) async {
    await pumpApp(
      tester,
      seed: (backend) {
        backend.addProfile('me', name: 'Me');
        backend.addGroup('Club');
      },
    );

    await tester.tap(find.text('Club'));
    await tester.pumpAndSettle();
    expect(find.text('Get your group going'), findsOneWidget);

    await tester.tap(find.text('Add the first event'));
    await tester.pumpAndSettle();
    expect(find.byType(ScheduleCreateScreen), findsOneWidget);
  });

  testWidgets('signing out shows the sign-in page', (tester) async {
    await pumpApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);

    backend.auth.signIn(null);
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
