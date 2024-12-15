import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

class DefaultRulesRepository extends SupabaseRepository with Postgrest {
  DefaultRulesRepository({required super.supabase})
      : super(tableName: Tables.default_rules);

  Future<Iterable<DefaultRule>> getDefaultRules(String groupId) async {
    return table()
        .select('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .withConverter((data) => data.map(DefaultRule.fromJson));
  }

  Future<DefaultRule> createDefaultRule(DefaultRule reply) async {
    return table()
        .upsert({
          'schedule_id': reply.scheduleId,
          'member_id': reply.memberId,
          'selected_option': reply.selectedOption.name,
          'recurrence_rule': reply.recurrenceRule,
        })
        .select()
        .single()
        .withConverter((data) => DefaultRule.fromJson(data));
  }

  Future<void> deleteDefaultRule(
      {required String memberId, required String scheduleId}) async {
    return table()
        .delete()
        .eq('member_id', memberId)
        .eq('schedule_id', scheduleId);
  }
}
