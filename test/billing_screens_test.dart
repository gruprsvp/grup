// The paid features in the app, end to end on the in-memory backend: cutoff
// locks (docs/billing-and-entitlements.md 16.5).
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/app.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/router.dart';
import 'package:provider/provider.dart';

import 'support/fake_backend.dart';
import 'support/fake_supabase.dart';
import 'support/harness.dart';

void main() {
  setUpAll(initFakeSupabase);

  late FakeBackend backend;
  late Repositories repositories;
  late GoRouter router;
  late Group club;

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
}
