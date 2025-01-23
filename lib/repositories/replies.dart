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
    final members = await repository.get<Member>(
        query: Query.where('group', Where.exact('id', groupId)));
    final replies = await members
        .map((member) => repository.get<Reply>(
              query: Query.where('member', Where.exact('id', member.id)),
            ))
        .wait;
    return replies.expand((element) => element);
  }

  Future<Reply> upsertReply(Reply reply) async {
    return repository.upsert(reply);
  }

  Future<bool> deleteReply({
    required Reply reply,
  }) async {
    return repository.delete<Reply>(reply, query: Query.where('id', reply.id));
  }
}
