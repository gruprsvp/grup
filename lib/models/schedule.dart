import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rrule/rrule.dart';

part 'schedule.freezed.dart';

part 'schedule.g.dart';

@freezed
sealed class Schedule with _$Schedule {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Schedule({
    required String id,
    required String groupId,
    required String displayName,
    required DateTime startDate,
    required RecurrenceRule recurrenceRule,

    /// Replies close this long before each occurrence (reply_cutoffs).
    int? cutoffMinutesBefore,

    /// The IANA time zone the occurrences' wall-clock times are in, set
    /// with the cutoff: the server reads them there.
    String? timeZone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}

/// When an occurrence starts and when changes to it close.
///
/// shortcut: read in the device's time zone, not [Schedule.timeZone] (the
/// app has no time zone database). The server, which decides, uses the
/// schedule's; they agree whenever the device is where the group meets.
extension ReplyCutoff on Schedule {
  /// The moment the occurrence at [instanceDate] starts. Occurrences carry
  /// the wall-clock time in UTC fields.
  DateTime startsAt(DateTime instanceDate) => DateTime(
    instanceDate.year,
    instanceDate.month,
    instanceDate.day,
    instanceDate.hour,
    instanceDate.minute,
  );

  /// When changes to the occurrence at [instanceDate] close, or `null`
  /// without a cutoff.
  DateTime? closesAt(DateTime instanceDate) => switch (cutoffMinutesBefore) {
    final minutes? => startsAt(
      instanceDate,
    ).subtract(Duration(minutes: minutes)),
    null => null,
  };
}
