import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class SchedulesRepository extends SupabaseRepository {
  const SchedulesRepository({required super.repository});

  Future<Schedule> createSchedule(Schedule schedule) async {
    return repository.upsert(schedule);
  }

  Future<Iterable<Schedule>> getGroupSchedules(String groupId) async {
    return repository.get<Schedule>(
        query: Query.where('group', Where.exact('id', groupId)));
  }

  Future<bool> deleteSchedule(Schedule schedule) async {
    return repository.delete(schedule);
  }
}
