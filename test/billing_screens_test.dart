// The paid features in the app, end to end on the in-memory backend: the
// plan page and its return from Stripe, spots, cutoff locks, the kitchen
// view and the export (docs/billing-and-entitlements.md 16.5).
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import 'support/fake_backend.dart';
import 'support/fake_supabase.dart';
import 'support/harness.dart';

final _catalog = [
  for (final (code, rank, seats, month) in [
    ('community_s', 10, 20, 900),
    ('community_m', 20, 40, 1900),
    ('community_l', 30, 80, 3500),
  ])
    CatalogPlan(
      plan: code,
      rank: rank,
      features: [
        FeatureKey.kitchenView,
        FeatureKey.replyCutoffs,
        FeatureKey.exportCsv,
      ],
      limits: {LimitKey.maxSeats: seats},
      prices: [
        CatalogPrice(
          provider: 'stripe',
          id: '${code}_month',
          interval: 'month',
          amounts: {'CHF': month, 'EUR': month, 'USD': month},
        ),
        CatalogPrice(
          provider: 'stripe',
          id: '${code}_year',
          interval: 'year',
          amounts: {'CHF': month * 10, 'EUR': month * 10, 'USD': month * 10},
        ),
      ],
    ),
];

void main() {
  setUpAll(initFakeSupabase);

  late FakeBackend backend;
  late Repositories repositories;
  late GoRouter router;
  late Group club;

  /// URLs the app opened (Stripe's pages), through url_launcher's channel.
  late List<String> launched;

  setUp(() {
    launched = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (call) async {
            launched.add((call.arguments as Map)['url'] as String);
            return true;
          },
        );
  });

  tearDown(() {
    debugIsWeb = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
  });

  Future<void> pumpApp(
    WidgetTester tester,
    String location, {
    String? userId = 'me',
    void Function(FakeBackend backend)? seed,
  }) async {
    (backend, repositories) = await fakeApp(
      userId: userId,
      seed: (backend) {
        backend.userId = 'me';
        backend.addProfile('me', name: 'Me');
        club = backend.addGroup('Club');
        backend.catalog = _catalog;
        backend.billingMode = BillingMode.live;
        backend.userId = userId;
        seed?.call(backend);
      },
    );
    router = createRouter(repositories.auth)..go(location);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MultiProvider(
        providers: repositories.providers,
        child: ParApp(router: router, settings: repositories.settings),
      ),
    );
    await tester.pumpAndSettle();
  }

  String path() => router.routeInformationProvider.value.uri.path;

  Finder inCard(String title, Finder finder) =>
      find.descendant(of: find.widgetWithText(Card, title), matching: finder);

  group('the plan page, on the web', () {
    setUp(() => debugIsWeb = true);

    /// Lets the page open, without pumpAndSettle: while a plan activates its
    /// spinner turns, and settling would wait out the whole minute.
    Future<void> pumpAWhile(WidgetTester tester) async {
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('a free group picks a size, then monthly or yearly, and '
        'goes to Stripe to pay', (tester) async {
      await pumpApp(tester, '/', seed: (backend) => backend.isFounder = true);
      router.go('/groups/${club.id}/plan');
      await tester.pumpAndSettle();

      expect(find.byType(GroupPlanScreen), findsOneWidget);
      expect(find.widgetWithText(PlanMark, 'Free'), findsOneWidget);
      expect(find.text('1 of 10 spots taken'), findsOneWidget);
      await tester.scrollUntilVisible(find.text(r'Plans from $9 a month'), 200);
      await tester.pump();

      await tester.tap(find.text('Choose a plan'));
      await tester.pumpAndSettle();
      expect(find.text('Pick a size'), findsOneWidget);
      expect(inCard('Crew', find.text('Fits your group')), findsOneWidget);
      expect(inCard('Club', find.text(r'$19 a month')), findsOneWidget);

      await tester.tap(find.widgetWithText(Card, 'Club'));
      await tester.pumpAndSettle();
      expect(find.text('Up to 40 people'), findsOneWidget);
      expect(find.text(r'$19 a month'), findsOneWidget);
      expect(find.text(r'Or $190 a year: 2 months free'), findsOneWidget);
      expect(
        find.text('Your founder discount takes 30% off at checkout.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Yearly'));
      await tester.pumpAndSettle();
      expect(find.text(r'$190 a year'), findsOneWidget);
      expect(find.text('2 months free'), findsOneWidget);

      await tester.tap(find.text('Continue to payment'));
      await tester.pumpAndSettle();

      expect(backend.checkouts.single, (
        groupId: club.id,
        plan: 'community_m',
        interval: 'year',
      ));
      expect(launched, ['https://checkout.stripe.test/community_m-year']);
    });

    testWidgets('a founding group has no limit: the sheet goes straight to '
        'Crew, and paying starts when the founder perk ends', (tester) async {
      await pumpApp(
        tester,
        '/',
        seed: (backend) => backend.entitlements[club.id] = GroupEntitlements(
          features: const [FeatureKey.kitchenView],
          limits: const {LimitKey.maxSeats: null},
          sources: [
            const EntitlementSource(kind: 'grant', source: 'legacy'),
            EntitlementSource(
              kind: 'grant',
              source: 'founder_trial',
              until: DateTime.now().add(const Duration(days: 90)),
            ),
          ],
        ),
      );
      router.go('/groups/${club.id}/plan');
      await tester.pumpAndSettle();
      expect(find.text('1 spot taken'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Choose a plan'), 200);
      await tester.pump();
      await tester.tap(find.text('Choose a plan'));
      await tester.pumpAndSettle();

      expect(find.text('Pick a size'), findsNothing);
      expect(find.widgetWithText(PlanMark, 'Crew'), findsOneWidget);
      expect(find.text('No spot limit'), findsOneWidget);
      expect(find.textContaining('Nothing to pay until'), findsOneWidget);

      await tester.tap(find.text('Continue to payment'));
      await tester.pumpAndSettle();
      expect(backend.checkouts.single, (
        groupId: club.id,
        plan: 'community_s',
        interval: 'month',
      ));
    });

    testWidgets('a size too small for the group can\'t be picked', (
      tester,
    ) async {
      await pumpApp(
        tester,
        '/',
        seed: (backend) {
          for (var i = 0; i < 24; i++) {
            backend.addMember(club.id, profileId: 'p$i');
          }
        },
      );
      router.go('/groups/${club.id}/plan');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Choose a plan'), 200);
      await tester.pump();
      await tester.tap(find.text('Choose a plan'));
      await tester.pumpAndSettle();

      expect(
        inCard('Crew', find.text('Too small for your group')),
        findsOneWidget,
      );
      expect(inCard('Club', find.text('Fits your group')), findsOneWidget);
      await tester.tap(find.widgetWithText(Card, 'Crew'));
      await tester.pumpAndSettle();
      expect(find.text('Pick a size'), findsOneWidget);
    });

    testWidgets('the payer sees their plan, and manages it at Stripe', (
      tester,
    ) async {
      await pumpApp(
        tester,
        '/',
        seed: (backend) => backend.entitlements[club.id] = GroupEntitlements(
          features: const [FeatureKey.kitchenView],
          limits: const {LimitKey.maxSeats: 40},
          sources: [
            EntitlementSource(
              kind: 'subscription',
              plan: 'community_m',
              rank: 20,
              provider: 'stripe',
              status: 'active',
              payer: 'me',
              until: DateTime.utc(2026, 11, 25, 12),
              renews: true,
            ),
          ],
        ),
      );
      router.go('/groups/${club.id}/plan');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(PlanMark, 'Club'), findsOneWidget);
      expect(find.text('Paid by you · renews on Nov 25, 2026'), findsOneWidget);
      expect(find.text('1 of 40 spots taken'), findsOneWidget);
      expect(find.text('Choose a plan'), findsNothing);

      await tester.scrollUntilVisible(find.text('Manage billing'), 200);
      await tester.tap(find.text('Manage billing'));
      await tester.pumpAndSettle();
      expect(backend.portals, ['/groups/${club.id}/plan']);
      expect(launched, ['https://billing.stripe.test/portal']);
    });

    testWidgets('back from Stripe, the plan shows once it is active', (
      tester,
    ) async {
      // Stripe returns to the root: the web host answers nothing else.
      await pumpApp(tester, '/');
      router.go(
        '/?return=${Uri.encodeComponent('/groups/${club.id}/plan?checkout=success')}',
      );
      await pumpAWhile(tester);

      expect(path(), '/groups/${club.id}/plan');
      expect(find.text('Thanks! Switching on your plan…'), findsOneWidget);

      // Stripe's webhook lands.
      backend.entitlements[club.id] = const GroupEntitlements(
        limits: {LimitKey.maxSeats: 20},
        sources: [
          EntitlementSource(
            kind: 'subscription',
            plan: 'community_s',
            rank: 10,
            payer: 'me',
            status: 'active',
          ),
        ],
      );
      await tester.pump(GroupPlanViewModel.pollEvery);
      await tester.pumpAndSettle();

      expect(find.text('Thanks! Switching on your plan…'), findsNothing);
      expect(find.widgetWithText(PlanMark, 'Crew'), findsOneWidget);
      expect(find.text('Welcome to Crew! Every perk is on.'), findsOneWidget);
    });

    testWidgets('a slow activation says so after a minute', (tester) async {
      await pumpApp(tester, '/');
      router.go('/groups/${club.id}/plan?checkout=success');
      await pumpAWhile(tester);
      expect(find.text('Thanks! Switching on your plan…'), findsOneWidget);

      for (
        var waited = Duration.zero;
        waited < GroupPlanViewModel.pollFor;
        waited += GroupPlanViewModel.pollEvery
      ) {
        await tester.pump(GroupPlanViewModel.pollEvery);
      }
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Payment received. Activation is taking longer than usual; refresh in a minute.',
        ),
        findsOneWidget,
      );
    });
  });

  group('returning from an external page', () {
    testWidgets('?return opens that page; an absolute one goes home', (
      tester,
    ) async {
      debugIsWeb = true;
      await pumpApp(tester, '/?return=%2F%2Fevil.example');
      expect(path(), '/');
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('signed out, it goes through sign-in and comes back', (
      tester,
    ) async {
      debugIsWeb = true;
      await pumpApp(tester, '/', userId: null);
      router.go(
        '/?return=${Uri.encodeComponent('/groups/${club.id}/plan?checkout=success')}',
      );
      await tester.pumpAndSettle();
      expect(find.byType(AuthScreen), findsOneWidget);

      backend.auth.signIn('me');
      await tester.pumpAndSettle();

      expect(path(), '/groups/${club.id}/plan');
      expect(find.byType(GroupPlanScreen), findsOneWidget);
    });

    testWidgets('the apps have no plan page', (tester) async {
      await pumpApp(tester, '/');
      router.go('/groups/${club.id}/plan');
      await tester.pumpAndSettle();
      expect(path(), '/groups/${club.id}');
    });
  });

  group('spots', () {
    void full(FakeBackend backend) {
      backend.fundGroup(club.id, maxSeats: 2);
      backend.addMember(club.id, profileId: 'ann');
    }

    testWidgets('a full group says so; on the web it links to the plans', (
      tester,
    ) async {
      debugIsWeb = true;
      await pumpApp(tester, '/', seed: full);
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      expect(find.text('2 of 2 spots taken'), findsOneWidget);
      await tester.tap(find.text('Your group is full. Make room with a plan.'));
      await tester.pumpAndSettle();
      expect(find.byType(GroupPlanScreen), findsOneWidget);
    });

    testWidgets('inviting into a full group offers the plans on the web', (
      tester,
    ) async {
      debugIsWeb = true;
      await pumpApp(tester, '/', seed: full);
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invite some friends!'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Email'));
      await tester.pumpAndSettle();
      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Zoe');
      await tester.enterText(
        find.widgetWithText(TextField, 'Email'),
        'zoe@example.com',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Every spot in this group is taken.'), findsOneWidget);
      expect(
        backend.members.values.where((m) => m.displayNameOverride == 'Zoe'),
        isEmpty,
      );
      await tester.tap(find.widgetWithText(SnackBarAction, 'See plans'));
      await tester.pumpAndSettle();
      expect(find.byType(GroupPlanScreen), findsOneWidget);
    });

    testWidgets('in the apps it says how to free a spot, and no more', (
      tester,
    ) async {
      await pumpApp(tester, '/', seed: full);
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      expect(
        find.text('Remove members or pending invites to free a spot.'),
        findsOneWidget,
      );
      expect(find.text('See plans'), findsNothing);
      expect(find.byType(PlanMark), findsNothing);
    });

    testWidgets('below the limit, pending invites are said to take a spot', (
      tester,
    ) async {
      await pumpApp(tester, '/', seed: (b) => b.fundGroup(club.id));
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      expect(find.text('1 of 20 spots taken'), findsOneWidget);
      expect(
        find.text(
          'Pending invites hold a spot too. Guests you answer for are free.',
        ),
        findsOneWidget,
      );
    });
  });

  group('after an event\'s deadline', () {
    // An event 30 minutes from now, with changes closing an hour before.
    // Occurrences carry the wall-clock time in UTC fields.
    final soon = DateTime.now().add(const Duration(minutes: 30));
    final at = DateTime.utc(
      soon.year,
      soon.month,
      soon.day,
      soon.hour,
      soon.minute,
    );

    void lockedDinner(
      FakeBackend backend, {
      GroupRoles role = GroupRoles.admin,
    }) {
      backend.fundGroup(club.id);
      final dinner = backend.addSchedule(club.id, start: at);
      backend.schedules[dinner.id] = dinner.copyWith(
        cutoffMinutesBefore: 60,
        timeZone: 'Europe/Zurich',
      );
      final me = backend.members.values.single;
      backend.members[me.id] = me.copyWith(role: role);
      // Someone else administers the group.
      backend.addMember(club.id, profileId: 'admin', role: GroupRoles.admin);
      backend.addReply(
        Reply(
          memberId: me.id,
          scheduleId: dinner.id,
          instanceDate: at,
          selectedOption: ReplyOptions.yes,
        ),
      );
    }

    testWidgets('a member sees the answer, closed', (tester) async {
      await pumpApp(
        tester,
        '/',
        seed: (b) => lockedDinner(b, role: GroupRoles.member),
      );
      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Changes closed at'), findsOneWidget);
      expect(find.byTooltip('Yes'), findsNothing);
      expect(find.byTooltip('No'), findsNothing);
    });

    testWidgets('an admin can still switch, but not clear, the answer', (
      tester,
    ) async {
      await pumpApp(tester, '/', seed: lockedDinner);
      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Changes closed at'), findsOneWidget);
      // The active "yes" is a mark, not a button that would clear it.
      expect(find.byTooltip('Yes'), findsNothing);
      await tester.tap(find.byTooltip('No'));
      await tester.pumpAndSettle();
      expect(backend.replies.values.single.selectedOption, ReplyOptions.no);
    });
  });

  group('the kitchen view', () {
    final day = DateTime.now();
    final at = DateTime.utc(day.year, day.month, day.day, 12);

    void lunch(FakeBackend backend) {
      backend.fundGroup(club.id);
      backend.addProfile('ann', name: 'Ann');
      final ann = backend.addMember(club.id, profileId: 'ann');
      final guest = backend.addMember(club.id, name: 'Guest');
      final schedule = backend.addSchedule(club.id, name: 'Lunch', start: at);
      for (final member in [ann, guest]) {
        backend.addReply(
          Reply(
            memberId: member.id,
            scheduleId: schedule.id,
            instanceDate: at,
            selectedOption: ReplyOptions.yes,
          ),
        );
      }
    }

    testWidgets('counts and names who is coming, for any member', (
      tester,
    ) async {
      await pumpApp(tester, '/', seed: lunch);
      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Kitchen view'));
      await tester.pumpAndSettle();

      expect(path(), '/groups/${club.id}/kitchen');
      // Headcounts keep together on one line (non-breaking spaces).
      expect(find.text('2\u00A0coming'), findsOneWidget);
      expect(find.text('1 member · 1 guest'), findsOneWidget);
      expect(find.text('Ann, Guest'), findsOneWidget);
      expect(find.byTooltip('Print'), findsOneWidget);
    });

    testWidgets('is not offered without the feature, nor on iOS', (
      tester,
    ) async {
      await pumpApp(tester, '/', seed: (b) => b.billingMode = BillingMode.live);
      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Kitchen view'), findsNothing);

      // Opened anyway, from a link:
      router.go(
        '/groups/${club.id}/kitchen?date=${DateFormat('yyyy-MM-dd').format(day)}',
      );
      await tester.pumpAndSettle();
      expect(
        find.text('This isn\'t available for this group.'),
        findsOneWidget,
      );
    });

    testWidgets('iOS shows no pro screens while billing is live', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      await pumpApp(tester, '/', seed: lunch);
      await tester.tap(find.text('Club'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Kitchen view'), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('the export', () {
    /// Opens Export answers and enters [first] to [last] (mm/dd/yyyy).
    Future<void> exportRange(
      WidgetTester tester,
      String first,
      String last,
    ) async {
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Export answers'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Switch to input'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Start Date'),
        first,
      );
      await tester.enterText(find.widgetWithText(TextField, 'End Date'), last);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    }

    testWidgets('shares everyone\'s answers as a CSV file', (tester) async {
      final share = _FakeShare();
      SharePlatform.instance = share;
      await pumpApp(
        tester,
        '/',
        seed: (b) {
          b.fundGroup(club.id);
          b.addSchedule(
            club.id,
            name: 'Lunch',
            start: DateTime.utc(2026, 1, 1, 12),
          );
        },
      );
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      await exportRange(tester, '03/01/2026', '03/02/2026');

      final file = share.shared.single.files!.single;
      expect(file.mimeType, 'text/csv');
      expect(share.shared.single.fileNameOverrides, [
        'grup-answers-2026-03-01-2026-03-02.csv',
      ]);
      final bytes = await file.readAsBytes();
      // A byte order mark, so spreadsheets read the names as UTF-8.
      expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
      final csv = utf8.decode(bytes.skip(3).toList());
      expect(
        csv,
        startsWith('date,time,event,name,managed,answer,source,late\r\n'),
      );
      expect(csv, contains('2026-03-02,12:00,Lunch,Me,no,,none,no'));
    });

    testWidgets('refuses more than a year', (tester) async {
      final share = _FakeShare();
      SharePlatform.instance = share;
      await pumpApp(tester, '/', seed: (b) => b.fundGroup(club.id));
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      await exportRange(tester, '01/01/2025', '01/01/2026');

      expect(find.text('Choose at most a year.'), findsOneWidget);
      expect(share.shared, isEmpty);
    });

    testWidgets('is not in the menu without the feature', (tester) async {
      await pumpApp(tester, '/');
      router.go('/groups/${club.id}/manage');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      expect(find.text('Export answers'), findsNothing);
    });
  });
}

/// A share sheet that records what was shared.
class _FakeShare extends SharePlatform {
  final shared = <ShareParams>[];

  @override
  Future<ShareResult> share(ShareParams params) async {
    shared.add(params);
    return const ShareResult('ok', ShareResultStatus.success);
  }
}
