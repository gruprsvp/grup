import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class DefaultRepliesRepository extends SupabaseRepository {
  DefaultRepliesRepository({required super.repository});

  Future<Iterable<DefaultReply>> getDefaultReplies(int groupId) async {
    return repository.get<DefaultReply>(
      query: Query(where: [
        Where('member').isExactly(
          Where('group_id').isExactly(groupId),
        ),
      ]),
    );
  }

  Future<DefaultReply> createDefaultReply(DefaultReply reply) async {
    return repository.upsert<DefaultReply>(reply);
  }

  Future<DefaultReply> getDefaultReply(
      {required int memberId, required int scheduleId}) async {
    final list = await repository.get<DefaultReply>(
      query: Query(
        where: [
          Where('member').isExactly(memberId),
          Where('schedule').isExactly(scheduleId),
        ],
      ),
    );
    return list.first;
  }

  Future<bool> deleteDefaultReply(
      {required int memberId, required int scheduleId}) async {
    final reply =
        await getDefaultReply(memberId: memberId, scheduleId: scheduleId);
    return repository.delete<DefaultReply>(reply);
  }
}
