import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';

import 'const.dart';
import 'supabase.dart';

class RepliesService extends SupabaseService with Postgrest {
  const RepliesService({required super.supabase})
    : super(tableName: Tables.replies);

  Future<List<Reply>> getRepliesForDateRange(
    String groupId,
    DateTimeRange dateRange,
  ) async {
    return table()
        .select('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .gte('instance_date', dateRange.start)
        .lt('instance_date', dateRange.end)
        .withConverter((data) => decodeRows(data, Reply.fromJson));
  }

  Future<Reply> createReply(Reply reply) async {
    return table()
        .upsert({
          'schedule_id': reply.scheduleId,
          'member_id': reply.memberId,
          'instance_date': reply.instanceDate.toIso8601String(),
          'selected_option': reply.selectedOption.name,
        }, onConflict: 'member_id, schedule_id, instance_date')
        .select()
        .single()
        .withConverter((data) => Reply.fromJson(data));
  }

  // Selecting the deleted row makes a delete that matched nothing (already
  // gone, or hidden by row-level security) fail instead of looking done.
  Future<void> deleteReply({
    required String memberId,
    required String scheduleId,
    required DateTime instanceDate,
  }) async {
    await table()
        .delete()
        .eq('member_id', memberId)
        .eq('schedule_id', scheduleId)
        .eq('instance_date', instanceDate.toIso8601String())
        .select('member_id')
        .single();
  }
}
