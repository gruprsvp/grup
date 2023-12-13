import 'package:rrule/rrule.dart';

class CommonRecurrenceRules {
  static final RecurrenceRule daily = RecurrenceRule(
    frequency: Frequency.daily,
    interval: 1,
  );

  static final RecurrenceRule weekly = RecurrenceRule(
    frequency: Frequency.weekly,
    interval: 1,
  );

  static final RecurrenceRule monthly = RecurrenceRule(
    frequency: Frequency.monthly,
    interval: 1,
  );

  static final RecurrenceRule yearly = RecurrenceRule(
    frequency: Frequency.yearly,
    interval: 1,
  );

  static final RecurrenceRule weekdays = RecurrenceRule(
    frequency: Frequency.weekly,
    interval: 1,
    byWeekDays: {
      ByWeekDayEntry(DateTime.monday),
      ByWeekDayEntry(DateTime.tuesday),
      ByWeekDayEntry(DateTime.wednesday),
      ByWeekDayEntry(DateTime.thursday),
      ByWeekDayEntry(DateTime.friday),
    },
  );

  static final RecurrenceRule weekends = RecurrenceRule(
    frequency: Frequency.weekly,
    interval: 1,
    byWeekDays: {
      ByWeekDayEntry(DateTime.saturday),
      ByWeekDayEntry(DateTime.sunday),
    },
  );
}
