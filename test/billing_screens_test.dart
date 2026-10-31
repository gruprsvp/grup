// The paid features in the app, end to end on the in-memory backend: cutoff
// locks, the kitchen view and the export (docs/billing-and-entitlements.md
// 16.5).
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import 'support/fake_backend.dart';
import 'support/fake_supabase.dart';
import 'support/harness.dart';

void main() {
  setUpAll(initFakeSupabase);

  late FakeBackend backend;
  late Repositories repositories;
  late GoRouter router;
  late Group club;

  tearDown(() => debugIsWeb = null);

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
