import 'package:parousia/models/models.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class SchedulesService extends SupabaseService with Postgrest {
  const SchedulesService({required super.supabase})
    : super(tableName: Tables.schedules);

  Future<Schedule> createSchedule(Schedule schedule) async {
    return table()
        .insert({
          'id': const Uuid().v7(),
          'group_id': schedule.groupId,
          'display_name': schedule.displayName,
          'start_date': schedule.startDate.toIso8601String(),
          'recurrence_rule': schedule.recurrenceRule,
        })
        .select()
        .single()
        .withConverter((data) => Schedule.fromJson(data));
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
