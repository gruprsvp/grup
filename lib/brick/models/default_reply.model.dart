import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:parousia/brick/models/member.model.dart';
import 'package:parousia/brick/models/schedule.model.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:rrule/rrule.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'default_replies',
  ),
)
class DefaultReply extends OfflineFirstWithSupabaseModel {
  @Supabase(foreignKey: 'member_id')
  final Member member;

  @Supabase(foreignKey: 'schedule_id')
  final Schedule schedule;

  final ReplyOptions selectedOption;
  final RecurrenceRule recurrenceRule;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DefaultReply({
    required this.member,
    required this.schedule,
    required this.selectedOption,
    required this.recurrenceRule,
    this.createdAt,
    this.updatedAt,
  });
}
