import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class SchedulesRepository {
  SchedulesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Schedule> createSchedule(Schedule schedule) async {
    return _table()
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
    return _table()
        .select()
        .eq('group_id', groupId)
        .withConverter((data) => data.map(Schedule.fromJson));
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.schedules.name);
}
