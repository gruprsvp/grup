import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

class DefaultRepliesRepository extends SupabaseRepository with Postgrest {
  DefaultRepliesRepository({required super.supabase})
      : super(tableName: Tables.default_replies);

  Future<Iterable<DefaultReply>> getDefaultReplies(int groupId) async {
    return table()
        .select('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .withConverter((data) => data.map(DefaultReply.fromJson));
  }

  Future<DefaultReply> createDefaultReply(DefaultReply reply) async {
    return table()
        .upsert({
          'schedule_id': reply.scheduleId,
          'member_id': reply.memberId,
          'selected_option': reply.selectedOption.name,
          'recurrence_rule': reply.recurrenceRule,
        })
        .select()
        .single()
        .withConverter((data) => DefaultReply.fromJson(data));
  }
}
