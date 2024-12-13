import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';

import 'const.dart';
import 'supabase.dart';

class SchedulesRepository extends SupabaseRepository with Postgrest {
  const SchedulesRepository({required super.supabase})
      : super(tableName: Tables.schedules);

  Future<Schedule> createSchedule(Schedule schedule) async {
    return table()
        .insert({
          'group_id': schedule.groupId,
          'display_name': schedule.displayName,
          'start_date': schedule.startDate.toIso8601String(),
          'recurrence_rule': schedule.recurrenceRule,
        })
        .select()
        .single()
        .withConverter((data) => Schedule.fromJson(data));
  }

  Future<Iterable<Schedule>> getGroupSchedules(int groupId) async {
    return table()
        .select('*,replies(*),default_rules(*)')
        .eq('group_id', groupId)
        .withConverter((data) => data.map(Schedule.fromJson));
  }

  Future<void> deleteSchedule(String scheduleId) async {
    return table().delete().eq('id', scheduleId);
  }
}
