import 'package:flutter/material.dart';

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

  DateTimeRange getDayRange() {
    final start = getDayStart();
    final end = start.add(const Duration(days: 1));

    return DateTimeRange(start: start, end: end);
  }
}
