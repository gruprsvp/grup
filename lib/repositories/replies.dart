import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class RepliesRepository {
  RepliesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Iterable<Reply>> getRepliesForDay(int groupId, DateTime day) async {
    return getRepliesForDateRange(groupId, day.toUtc().getDayRange());
  }

  Future<Iterable<Reply>> getRepliesForDateRange(
      int groupId, DateTimeRange dateRange) async {
    return _table()
        .select('*,members!inner(*)')
        .eq('members.group_id', groupId)
        .gte('event_date', dateRange.start)
        .lt('event_date', dateRange.end)
        .withConverter((data) => data.map(Reply.fromJson));
  }

  Future<Reply> createReply(Reply reply) async {
    return _table()
        .insert({
          'schedule_id': reply.scheduleId,
          'member_id': reply.memberId,
          'event_date': reply.eventDate.toIso8601String(),
          'selected_option': reply.selectedOption.name,
        })
        .select()
        .single()
        .withConverter((data) => Reply.fromJson(data));
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.replies.name);
}
