import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class DefaultRepliesRepository {
  DefaultRepliesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Iterable<DefaultReply>> getDefaultReplies(int groupId) async {
    return _table()
        .select<PostgrestList>('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .withConverter((data) => data.map(DefaultReply.fromJson));
  }

  Future<DefaultReply> createDefaultReply(DefaultReply reply) async {
    return _table()
        .insert({
          'schedule_id': reply.scheduleId,
          'member_id': reply.memberId,
          'selected_option': reply.selectedOption.name,
          'recurrence_rule': reply.recurrenceRule,
        })
        .single()
        .select()
        .withConverter((data) => DefaultReply.fromJson(data));
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.default_replies.name);
}
