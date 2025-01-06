import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class DefaultRulesRepository extends SupabaseRepository {
  DefaultRulesRepository({required super.repository});

  Future<Iterable<DefaultRule>> getDefaultRules(String groupId) async =>
      repository.get<DefaultRule>(
        query: Query.where('members.group_id', groupId),
      );

  Future<DefaultRule> createDefaultRule(DefaultRule reply) async =>
      repository.upsert<DefaultRule>(reply);

  Future<DefaultRule> getDefaultRule(
      {required String memberId, required String scheduleId}) async {
    final list = await repository.get<DefaultRule>(
      query: Query(
        where: [
          Where('members.id').isExactly(memberId),
          Where('schedules.id').isExactly(scheduleId),
        ],
      ),
    );
    return list.first;
  }

  Future<bool> deleteDefaultRule(DefaultRule rule) =>
      repository.delete<DefaultRule>(rule);
}
