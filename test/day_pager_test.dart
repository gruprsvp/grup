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
            child: ListView(children: const [Text('day')]),
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

  testWidgets('a nudge below the threshold stays on the day', (tester) async {
    final dates = await pump(tester);

    await swipe(tester, dx: 5, at: Duration.zero, events: 3);

    expect(dates, isEmpty);
  });
}
