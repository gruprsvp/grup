import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/widgets/day_pager.dart';

void main() {
  // The night clocks go back in Europe: there, this also checks that a day
  // is a calendar day, not 24 hours.
  final start = DateTime(2026, 10, 25);

  Future<List<DateTime>> pump(WidgetTester tester) async {
    final dates = <DateTime>[];
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => DayPager(
            date: dates.lastOrNull ?? start,
            onDateChanged: (date) => setState(() => dates.add(date)),
            itemBuilder: (context, day) =>
                ListView(children: [Text('${day.month}/${day.day}')]),
          ),
        ),
      ),
    );
    return dates;
  }

  // A gesture: scroll events 16ms apart, momentum included.
  Future<void> swipe(
    WidgetTester tester, {
    required double dx,
    required Duration at,
    int events = 30,
  }) async {
    final center = tester.getCenter(find.byType(DayPager));
    for (var i = 0; i < events; i++) {
      await tester.sendEventToBinding(
        PointerScrollEvent(
          timeStamp: at + Duration(milliseconds: 16 * i),
          position: center,
          scrollDelta: Offset(dx, 0),
        ),
      );
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('a sideways scroll gesture moves one day, however long', (
    tester,
  ) async {
    final dates = await pump(tester);

    await swipe(tester, dx: 40, at: Duration.zero);
    expect(dates, [DateTime(2026, 10, 26)]);

    // After a pause, the next gesture moves one more, either way.
    await swipe(tester, dx: -40, at: const Duration(seconds: 2));
    expect(dates.last, start);
  });

  group('a drag', () {
    testWidgets('shows the next day as it comes in', (tester) async {
      final dates = await pump(tester);
      final width = tester.getSize(find.byType(DayPager)).width;

      final drag = await tester.startGesture(
        tester.getCenter(find.byType(DayPager)),
      );
      await drag.moveBy(const Offset(-kDragSlopDefault * 2, 0)); // the slop
      await drag.moveBy(Offset(-width * 0.3, 0));
      await tester.pump();

      expect(find.text('10/25'), findsOneWidget);
      expect(find.text('10/26'), findsOneWidget);
      expect(dates, isEmpty);
      await drag.up();
      await tester.pumpAndSettle();
    });

    testWidgets('past halfway and back stays on the day', (tester) async {
      final dates = await pump(tester);
      final width = tester.getSize(find.byType(DayPager)).width;

      final drag = await tester.startGesture(
        tester.getCenter(find.byType(DayPager)),
      );
      await drag.moveBy(const Offset(-kDragSlopDefault * 2, 0)); // the slop
      await drag.moveBy(Offset(-width * 0.3, 0));
      await tester.pump();
      await drag.moveBy(Offset(-width * 0.3, 0));
      await tester.pump();
      await drag.moveBy(Offset(width * 0.6, 0));
      await tester.pump();
      await drag.up();
      await tester.pumpAndSettle();

      expect(dates, isEmpty);
      expect(find.text('10/25'), findsOneWidget);
    });

    testWidgets('released past halfway moves one day', (tester) async {
      final dates = await pump(tester);
      final width = tester.getSize(find.byType(DayPager)).width;

      await tester.drag(find.byType(DayPager), Offset(width * 0.6, 0));
      await tester.pumpAndSettle();

      expect(dates, [DateTime(2026, 10, 24)]);
      expect(find.text('10/24'), findsOneWidget);
      expect(find.text('10/25'), findsNothing);
    });
  });

  testWidgets('a date set from outside shows on the current page', (
    tester,
  ) async {
    var date = start;
    late StateSetter setDate;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            setDate = setState;
            return DayPager(
              date: date,
              onDateChanged: (value) => setState(() => date = value),
              itemBuilder: (context, day) => Text('${day.month}/${day.day}'),
            );
          },
        ),
      ),
    );
    await tester.drag(find.byType(DayPager), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(date, DateTime(2026, 10, 26));

    setDate(() => date = DateTime(2026, 12, 1));
    await tester.pump();
    expect(find.text('12/1'), findsOneWidget);

    // And swiping goes on from there.
    await tester.drag(find.byType(DayPager), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(date, DateTime(2026, 12, 2));
  });

  testWidgets('a nudge below the threshold stays on the day', (tester) async {
    final dates = await pump(tester);

    await swipe(tester, dx: 5, at: Duration.zero, events: 3);

    expect(dates, isEmpty);
  });
}
