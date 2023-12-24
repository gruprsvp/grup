import 'package:flutter/material.dart';

export 'package:flutter/material.dart' show DateTimeRange;

extension DayRange on DateTime {
  DateTime getDayStart() {
    return copyWith(
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
      isUtc: true,
    );
  }

  DateTime getDayEnd() {
    return copyWith(
      hour: 23,
      minute: 59,
      second: 59,
      millisecond: 999,
      microsecond: 999,
      isUtc: true,
    );
  }

  DateTimeRange getDayRange() {
    final start = getDayStart();
    final end = getDayEnd();

    return DateTimeRange(start: start, end: end);
  }

  DateTimeRange getNdayRange(int n) {
    final start = getDayStart().add(Duration(days: -n));
    final end = getDayEnd().add(Duration(days: n));

    return DateTimeRange(start: start, end: end);
  }
}

extension DateTimeRangeCompare on DateTimeRange {
  bool contains(DateTime dateTime) {
    return start.isBefore(dateTime) && end.isAfter(dateTime);
  }
}
