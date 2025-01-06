import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:parousia/brick/models/group.model.dart';
import 'package:rrule/rrule.dart';
import 'package:uuid/v7.dart';

part 'schedule.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'schedules',
  ),
)
@MappableClass()
class Schedule extends OfflineFirstWithSupabaseModel with ScheduleMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String? id;

  @Supabase(foreignKey: 'group_id')
  final Group group;

  final String displayName;
  final DateTime startDate;
  final RecurrenceRule recurrenceRule;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Schedule({
    required this.group,
    required this.displayName,
    required this.startDate,
    required this.recurrenceRule,
    this.createdAt,
    this.updatedAt,
    String? id,
  }) : id = id ?? const UuidV7().generate();
}
