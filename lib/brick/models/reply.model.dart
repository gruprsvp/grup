import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:parousia/brick/models/member.model.dart';
import 'package:parousia/brick/models/schedule.model.dart';
import 'package:parousia/models/models.dart';

part 'reply.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'replies',
  ),
)
@MappableClass()
class Reply extends OfflineFirstWithSupabaseModel with ReplyMappable {
  @Supabase(foreignKey: 'member_id')
  @Sqlite(unique: true)
  final Member member;

  @Supabase(foreignKey: 'schedule_id')
  @Sqlite(unique: true)
  final Schedule schedule;

  @Sqlite(unique: true, index: true)
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
