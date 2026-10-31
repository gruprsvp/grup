import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:parousia/models/models.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class SchedulesService extends SupabaseService with Postgrest {
  const SchedulesService({
    required super.supabase,
    this.timeZone = deviceTimeZone,
  }) : super(tableName: Tables.schedules);

  /// The IANA time zone of the user's wall clock, written with a cutoff.
  final Future<String> Function() timeZone;

  Future<Schedule> createSchedule(Schedule schedule) async {
    final cutoff = schedule.cutoffMinutesBefore;
    return table()
        .insert({
          'id': const Uuid().v7(),
          'group_id': schedule.groupId,
          'display_name': schedule.displayName,
          'start_date': schedule.startDate.toIso8601String(),
          'recurrence_rule': schedule.recurrenceRule,
          if (cutoff != null) ...{
            'cutoff_minutes_before': cutoff,
            'time_zone': await timeZone(),
          },
        })
        .select()
        .single()
        .withConverter((data) => Schedule.fromJson(data));
  }

  /// Closes changes to replies [minutes] before each occurrence, or never
  /// when null. Needs the group to have reply_cutoffs to turn on.
  Future<Schedule> updateCutoff(String scheduleId, int? minutes) async {
    return table()
        .update({
          'cutoff_minutes_before': minutes,
          if (minutes != null) 'time_zone': await timeZone(),
        })
        .eq('id', scheduleId)
        .select()
        .single()
        .withConverter(Schedule.fromJson);
  }

  Future<List<Schedule>> getGroupSchedules(String groupId) async {
    return table()
        .select()
        .eq('group_id', groupId)
        .withConverter((data) => decodeRows(data, Schedule.fromJson));
  }

  // Selecting the deleted row makes a delete that matched nothing (already
  // gone, or hidden by row-level security) fail instead of looking done.
  Future<void> deleteSchedule(String scheduleId) async {
    await table().delete().eq('id', scheduleId).select('id').single();
  }
}

/// The device's IANA time zone, e.g. `Europe/Zurich`.
Future<String> deviceTimeZone() async =>
    (await FlutterTimezone.getLocalTimezone()).identifier;
