import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

void main() {
  group('getNameInitials', () {
    test('should return the initials of a name',
        () => expect(getNameInitials('John Doe'), 'JD'));

    test('should support simple emojis',
        () => expect(getNameInitials('👨 Test'), '👨T'));

    test('should support complex emojis',
        () => expect(getNameInitials('👨‍👩‍👧‍👦 Ciao'), '👨‍👩‍👧‍👦C'));
  });

  group('getNdayRange', () {
    test('should return the range of days from a date', () {
      initializeTimeZones();
      final location = getLocation('Europe/London');
      final dateString = '2021-01-01 12:00:00';
      final date = DateTime.parse(dateString);
      print(date.isUtc);
      print(date);
      print(TZDateTime.parse(location, dateString));
      print(TZDateTime.from(date, location));
      final tzDate = TZDateTime(location, date.year, date.month, date.day,
          date.hour, date.minute, date.second);
      final utcDate = tzDate.toUtc();
      print(tzDate);
      print(TZDateTime.from(utcDate.add(Duration(days: 6 * 30)), location));

      final rrule = RecurrenceRule(
        frequency: Frequency.monthly,
        interval: 1,
      );

      final instances = rrule
          .getInstances(
            start: tzDate.copyWith(isUtc: true),
            before: tzDate.copyWith(isUtc: true).add(Duration(days: 6 * 30)),
          )
          .map((e) => TZDateTime.from(e.copyWith(isUtc: false), location))
          .toList();

      print(instances[0]);
      print(instances[5]);
      print(instances[0].copyWith(isUtc: false));
      print(instances[5].copyWith(isUtc: false));
    });
  });
}
