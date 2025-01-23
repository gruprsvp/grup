// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<DefaultRule> _$DefaultRuleFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return DefaultRule(
      id: data['id'] == null ? null : data['id'] as String?,
      member: await MemberAdapter().fromSupabase(data['member'],
          provider: provider, repository: repository),
      schedule: await ScheduleAdapter().fromSupabase(data['schedule'],
          provider: provider, repository: repository),
      selectedOption: data['selected_option'] == null
          ? null
          : ReplyOptions.values.byName(data['selected_option']),
      recurrenceRule: data['recurrence_rule'] == null
          ? null
          : RecurrenceRule.fromJson(
              data['recurrence_rule'] as Map<String, dynamic>));
}

Future<Map<String, dynamic>> _$DefaultRuleToSupabase(DefaultRule instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'member_id': instance.memberId,
    'schedule_id': instance.scheduleId,
    'selected_option': instance.selectedOption?.name,
    'recurrence_rule': instance.recurrenceRule?.toJson()
  };
}

Future<DefaultRule> _$DefaultRuleFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return DefaultRule(
      id: data['id'] == null ? null : data['id'] as String?,
      member: (await repository!.getAssociation<Member>(
        Query.where('primaryKey', data['member_Member_brick_id'] as int,
            limit1: true),
      ))!
          .first,
      schedule: (await repository.getAssociation<Schedule>(
        Query.where('primaryKey', data['schedule_Schedule_brick_id'] as int,
            limit1: true),
      ))!
          .first,
      selectedOption: data['selected_option'] == null
          ? null
          : (data['selected_option'] > -1
              ? ReplyOptions.values[data['selected_option'] as int]
              : null),
      recurrenceRule: data['recurrence_rule'] == null
          ? null
          : RecurrenceRule.fromJson(
              jsonDecode(data['recurrence_rule'] as String)
                  as Map<String, dynamic>))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$DefaultRuleToSqlite(DefaultRule instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'member_Member_brick_id': instance.member.primaryKey ??
        await provider.upsert<Member>(instance.member, repository: repository),
    'schedule_Schedule_brick_id': instance.schedule.primaryKey ??
        await provider.upsert<Schedule>(instance.schedule,
            repository: repository),
    'selected_option': instance.selectedOption != null
        ? ReplyOptions.values.indexOf(instance.selectedOption!)
        : null,
    'recurrence_rule': instance.recurrenceRule != null
        ? jsonEncode(instance.recurrenceRule!.toJson())
        : null
  };
}

/// Construct a [DefaultRule]
class DefaultRuleAdapter extends OfflineFirstWithSupabaseAdapter<DefaultRule> {
  DefaultRuleAdapter();

  @override
  final supabaseTableName = 'default_rules';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'member': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'member',
      associationType: Member,
      associationIsNullable: false,
      foreignKey: 'member_id',
    ),
    'schedule': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'schedule',
      associationType: Schedule,
      associationIsNullable: false,
      foreignKey: 'schedule_id',
    ),
    'memberId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'member_id',
    ),
    'scheduleId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'schedule_id',
    ),
    'selectedOption': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'selected_option',
    ),
    'recurrenceRule': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recurrence_rule',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {'id'};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
    ),
    'id': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'id',
      iterable: false,
      type: String,
    ),
    'member': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'member_Member_brick_id',
      iterable: false,
      type: Member,
    ),
    'schedule': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'schedule_Schedule_brick_id',
      iterable: false,
      type: Schedule,
    ),
    'selectedOption': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'selected_option',
      iterable: false,
      type: ReplyOptions,
    ),
    'recurrenceRule': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recurrence_rule',
      iterable: false,
      type: Map,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      DefaultRule instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `DefaultRule` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'DefaultRule';

  @override
  Future<DefaultRule> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultRuleFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(DefaultRule input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultRuleToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<DefaultRule> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultRuleFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(DefaultRule input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultRuleToSqlite(input,
          provider: provider, repository: repository);
}
