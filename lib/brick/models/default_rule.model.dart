import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:parousia/brick/models/member.model.dart';
import 'package:parousia/brick/models/schedule.model.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:rrule/rrule.dart';

part 'default_rule.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'default_replies',
  ),
)
@MappableClass()
class DefaultRule extends OfflineFirstWithSupabaseModel
    with DefaultRuleMappable {
  @Supabase(foreignKey: 'member_id')
  final Member member;

  @Supabase(foreignKey: 'schedule_id')
  final Schedule schedule;

  final ReplyOptions selectedOption;
  final RecurrenceRule recurrenceRule;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DefaultRule({
    required this.member,
    required this.schedule,
    required this.selectedOption,
    required this.recurrenceRule,
    this.createdAt,
    this.updatedAt,
  });
}
