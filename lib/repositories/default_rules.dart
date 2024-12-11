import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class DefaultRulesRepository extends SupabaseRepository {
  DefaultRulesRepository({required super.repository});

  Future<Iterable<DefaultRule>> getDefaultRules(String groupId) async {
    return repository.get<DefaultRule>(
      query: Query(where: [
        Where('member').isExactly(
          Where('group_id').isExactly(groupId),
        ),
      ]),
    );
  }

  Future<DefaultRule> createDefaultRule(DefaultRule reply) async {
    return repository.upsert<DefaultRule>(reply);
  }

  Future<DefaultRule> getDefaultRule(
      {required String memberId, required String scheduleId}) async {
    final list = await repository.get<DefaultRule>(
      query: Query(
        where: [
          Where('member').isExactly(memberId),
          Where('schedule').isExactly(scheduleId),
        ],
      ),
    );
    return list.first;
  }

  Future<bool> deleteDefaultRule(
      {required String memberId, required String scheduleId}) async {
    final rule =
        await getDefaultRule(memberId: memberId, scheduleId: scheduleId);
    return repository.delete<DefaultRule>(rule);
  }
}
