import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:rrule/rrule.dart';

part 'default_rule.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'default_rules',
  ),
)
@MappableClass()
class DefaultRule extends OfflineFirstWithSupabaseModel
    with DefaultRuleMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String? id;

  @Supabase(foreignKey: 'member_id', ignoreTo: true)
  final Member member;

  @Supabase(foreignKey: 'schedule_id', ignoreTo: true)
  final Schedule schedule;

  @Sqlite(ignore: true)
  String get memberId => member.id;

  @Sqlite(ignore: true)
  String get scheduleId => schedule.id;

  @Supabase(enumAsString: true)
  final ReplyOptions? selectedOption;
  final RecurrenceRule? recurrenceRule;

  DefaultRule({
    required this.member,
    required this.schedule,
    this.recurrenceRule,
    this.selectedOption,
    String? id,
  }) : id = id ?? [member.id, schedule.id].join('-');
}
