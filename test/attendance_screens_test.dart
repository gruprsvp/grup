// The group's day list and an event's roster, as screens: what they claim
// before the data is known, what screen readers hear, and that pulling down
// refreshes. The full flow (answers saved, undo) is in app_flow_test.dart.
import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:material_ui/material_ui.dart';
import 'package:parousia/app.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/recurrence_rules.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget wrap(Widget screen) => MaterialApp(
    theme: appTheme(Brightness.light),
    localizationsDelegates: appLocalizationsDelegates,
    supportedLocales: appSupportedLocales,
    home: screen,
  );

  final day = DateTime.utc(2024, 1, 6);
  final at = DateTime.utc(2024, 1, 6, 10);
  final club = Group(id: 'g', displayName: 'Club');
  final game = Schedule(
    id: 's',
    groupId: 'g',
    displayName: 'Game',
    startDate: at,
    recurrenceRule: CommonRecurrenceRules.weekly,
  );
  final me = Member(id: 'me', groupId: 'g', role: GroupRoles.admin);
  final marta = Member(
    id: 'marta',
    groupId: 'g',
    role: GroupRoles.member,
    displayNameOverride: 'Marta Rossi',
  );

  /// Marta said yes; the user is in only by their usual answer.
  ScheduleInstanceSummary summary() => getScheduleInstances(
    schedule: game,
    startDate: day,
    endDate: day.add(const Duration(days: 1)),
    members: [me, marta],
    targetMemberId: me.id,
    replies: [
      Reply(
        memberId: marta.id,
        scheduleId: game.id,
        instanceDate: at,
        selectedOption: ReplyOptions.yes,
      ),
    ],
    defaultRules: [
      DefaultRule(
        memberId: me.id,
        scheduleId: game.id,
        selectedOption: ReplyOptions.yes,
        recurrenceRule: CommonRecurrenceRules.weekly,
      ),
    ],
  ).single;

  GroupDetailsScreen groupScreen({
    List<ScheduleInstanceSummary> instances = const [],
    bool hasSchedules = false,
    bool loading = false,
    Exception? error,
    Future<void> Function()? onRefresh,
  }) => GroupDetailsScreen(
    groupId: 'g',
    group: club,
    isAdmin: false,
    date: DateTime(2024, 1, 6),
    onDateChanged: (_) {},
    instancesOn: (_) => instances,
    hasSchedules: hasSchedules,
    loading: loading,
    error: error,
    onRefresh: onRefresh,
    onReplyChanged: (_, _) {},
  );

  group("an empty day doesn't guess", () {
    testWidgets('while the first load runs', (tester) async {
      await tester.pumpWidget(wrap(groupScreen(loading: true)));

      expect(find.textContaining('no events'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('when loading failed', (tester) async {
      await tester.pumpWidget(
        wrap(groupScreen(error: const NetworkException())),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('no events'), findsNothing);
      expect(find.textContaining("Couldn't reach GRUP"), findsOneWidget);
    });

    testWidgets('but says so once the group is known to be empty', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(groupScreen()));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'This group has no events yet.',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('a swipe shows the next day as it comes in', (tester) async {
    final dates = <DateTime>[];
    final saturday = DateTime(2024, 1, 6);
    await tester.pumpWidget(
      wrap(
        GroupDetailsScreen(
          groupId: 'g',
          group: club,
          isAdmin: false,
          date: saturday,
          onDateChanged: dates.add,
          // The game is on the Sunday; Saturday is empty.
          instancesOn: (day) => day == DateTime(2024, 1, 7) ? [summary()] : [],
          hasSchedules: true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final pager = find.byType(DayPager);
    final width = tester.getSize(pager).width;

    final drag = await tester.startGesture(tester.getCenter(pager));
    await drag.moveBy(const Offset(-kDragSlopDefault * 2, 0));
    await drag.moveBy(Offset(-width * 0.3, 0));
    await tester.pump();

    expect(find.text('No events on this day.'), findsOneWidget);
    expect(find.text('Game'), findsOneWidget);
    expect(dates, isEmpty);

    await drag.moveBy(Offset(-width * 0.3, 0));
    await drag.up();
    await tester.pumpAndSettle();

    expect(dates, [DateTime(2024, 1, 7)]);
    expect(tester.takeException(), isNull);
  });

  group('pulling down refreshes', () {
    Future<void> pullToRefresh(WidgetTester tester, Finder scrollable) async {
      await tester.fling(scrollable, const Offset(0, 400), 1000);
      await tester.pumpAndSettle();
    }

    testWidgets("a day's events", (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(
        wrap(
          groupScreen(
            instances: [summary()],
            hasSchedules: true,
            onRefresh: () async => refreshed++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await pullToRefresh(tester, find.text('Game'));
      expect(refreshed, 1);
    });

    testWidgets('an empty day', (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(
        wrap(
          groupScreen(hasSchedules: true, onRefresh: () async => refreshed++),
        ),
      );
      await tester.pumpAndSettle();

      await pullToRefresh(tester, find.text('No events on this day.'));
      expect(refreshed, 1);
    });

    testWidgets("an event's roster", (tester) async {
      var refreshed = 0;
      await tester.pumpWidget(
        wrap(
          GroupScheduleDetailsScreen(
            loading: false,
            group: club,
            scheduleInstance: scheduleInstanceDetails(summary(), [
              (me, null),
              (marta, null),
            ], canEditOthers: true),
            scheduleRule: game.recurrenceRule,
            onRefresh: () async => refreshed++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await pullToRefresh(tester, find.text('You'));
      expect(refreshed, 1);
    });
  });

  testWidgets('screen readers hear who answered what', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      wrap(
        GroupScheduleDetailsScreen(
          loading: false,
          group: club,
          scheduleInstance: scheduleInstanceDetails(summary(), [
            (me, null),
            (marta, null),
          ], canEditOthers: true),
          scheduleRule: game.recurrenceRule,
          onReplyChanged: ({
            required memberId,
            required reply,
            required previous,
            name,
          }) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Marta Rossi, coming'), findsOneWidget);
    // The row reads its subtitle ("Usually in") after the status.
    expect(
      find.bySemanticsLabel(RegExp(r'^You, usually coming')),
      findsOneWidget,
    );

    SemanticsNode button(String row) => tester.getSemantics(
      find.descendant(
        of: find.widgetWithText(ListTile, row),
        matching: find.byTooltip('Yes'),
      ),
    );

    // Marta's yes is an answer: selected.
    expect(
      button('Marta Rossi'),
      isSemantics(hasSelectedState: true, isSelected: true),
    );
    // The user's is only their usual answer: not selected, and said so.
    expect(
      button('You'),
      isSemantics(
        hasSelectedState: true,
        isSelected: false,
        value: 'usual answer',
      ),
    );
    semantics.dispose();
  });
}
