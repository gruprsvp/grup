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
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'member_id', ignoreTo: true)
  final Member member;

  @Supabase(foreignKey: 'schedule_id', ignoreTo: true)
  final Schedule schedule;

  @Sqlite(ignore: true)
  String get memberId => member.id;

  @Sqlite(ignore: true)
  String get scheduleId => schedule.id;

  final DateTime instanceDate;

  @Supabase(enumAsString: true)
  final ReplyOptions? selectedOption;

  Reply({
    required this.member,
    required this.schedule,
    required this.instanceDate,
    this.selectedOption,
    String? id,
  }) : id = id ?? [member.id, schedule.id, instanceDate].join('-');
}
