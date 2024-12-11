import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:parousia/brick/models/member.model.dart';
import 'package:parousia/brick/models/schedule.model.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'replies',
  ),
)
class Reply extends OfflineFirstWithSupabaseModel {
  @Supabase(foreignKey: 'member_id')
  final Member member;

  @Supabase(foreignKey: 'schedule_id')
  final Schedule schedule;

  final DateTime instanceDate;
  final ReplyOptions selectedOption;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Reply({
    required this.member,
    required this.schedule,
    required this.instanceDate,
    required this.selectedOption,
    this.createdAt,
    this.updatedAt,
  });
}
