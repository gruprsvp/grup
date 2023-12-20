import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class RepliesRepository {
  RepliesRepository({required this.supabase});

  final SupabaseClient supabase;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<Iterable<Reply>> getRepliesForDay(DateTime day) async {
    final dayRange = day.toUtc().getDayRange();
    final start = _dateFormat.format(dayRange.start);
    final end = _dateFormat.format(dayRange.end);
    return _table()
        .select<PostgrestList>()
        .gte('event_date', dayRange.start)
        .lt('event_date', dayRange.end)
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
        .single()
        .select()
        .withConverter((data) => Reply.fromJson(data));
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.replies.name);
}
