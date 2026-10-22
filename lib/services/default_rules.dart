import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

class DefaultRulesService extends SupabaseService with Postgrest {
  DefaultRulesService({required super.supabase})
    : super(tableName: Tables.defaultRules);

  Future<List<DefaultRule>> getDefaultRules(String groupId) async {
    return table()
        .select('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .withConverter((data) => decodeRows(data, DefaultRule.fromJson));
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

  // Selecting the deleted row makes a delete that matched nothing (already
  // gone, or hidden by row-level security) fail instead of looking done.
  Future<void> deleteDefaultRule({
    required String memberId,
    required String scheduleId,
  }) async {
    await table()
        .delete()
        .eq('member_id', memberId)
        .eq('schedule_id', scheduleId)
        .select('member_id')
        .single();
  }
}
