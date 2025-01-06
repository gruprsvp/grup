import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/util/util.dart';

import 'supabase.dart';

class RepliesRepository extends SupabaseRepository {
  const RepliesRepository({required super.repository});

  Future<Iterable<Reply>> getRepliesForDay(String groupId, DateTime day) async {
    return getRepliesForDateRange(groupId, day.toUtc().getDayRange());
  }

  Future<Iterable<Reply>> getRepliesForDateRange(
      String groupId, DateTimeRange dateRange) async {
    return repository.get<Reply>(
        query: Query(where: [
      Where('members.group_id').isExactly(groupId),
      Where('instance_date').isGreaterThanOrEqualTo(dateRange.start),
      Where('instance_date').isLessThan(dateRange.end)
    ]));
  }

  Future<Reply> createReply(Reply reply) async {
    return repository.upsert(reply);
  }

  Future<bool> deleteReply({
    required Reply reply,
  }) async {
    return repository.delete(reply);
  }
}
