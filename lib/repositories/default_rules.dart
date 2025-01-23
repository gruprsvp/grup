import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class DefaultRulesRepository extends SupabaseRepository {
  DefaultRulesRepository({required super.repository});

  Future<Iterable<DefaultRule>> getDefaultRules(String groupId) async =>
      repository
          .get<DefaultRule>(
        query: Query.where('member.group', Where.exact('id', groupId)),
      )
          .then((replies) {
        print(replies.length);
        return replies;
      });

  Future<DefaultRule> createDefaultRule(DefaultRule reply) async =>
      repository.upsert<DefaultRule>(reply);

  Future<DefaultRule> getDefaultRule(
      {required String memberId, required String scheduleId}) async {
    final list = await repository.get<DefaultRule>(
      query: Query(
        where: [
          Where.exact('member', Where.exact('id', memberId)),
          Where.exact('schedule', Where.exact('id', scheduleId)),
        ],
      ),
    );
    return list.first;
  }

  Future<bool> deleteDefaultRule(DefaultRule rule) =>
      repository.delete<DefaultRule>(
        rule,
        query: Query(
          where: [
            Where.exact('member', Where.exact('id', rule.memberId)),
            Where.exact('schedule', Where.exact('id', rule.scheduleId)),
          ],
        ),
      );
}
