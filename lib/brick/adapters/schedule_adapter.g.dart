// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Schedule> _$ScheduleFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Schedule(
      id: data['id'] as String?,
      group: await GroupAdapter().fromSupabase(data['group'],
          provider: provider, repository: repository),
      displayName: data['display_name'] as String,
      recurrenceRule: RecurrenceRule.fromJson(
          data['recurrence_rule'] as Map<String, dynamic>),
      startDate: DateTime.parse(data['start_date'] as String),
      timezone: data['timezone'] as String);
}

Future<Map<String, dynamic>> _$ScheduleToSupabase(Schedule instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'group_id': instance.groupId,
    'display_name': instance.displayName,
    'recurrence_rule': instance.recurrenceRule.toJson(),
    'start_date': instance.startDate.toIso8601String(),
    'timezone': instance.timezone
  };
}

Future<Schedule> _$ScheduleFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Schedule(
      id: data['id'] as String,
      group: (await repository!.getAssociation<Group>(
        Query.where('primaryKey', data['group_Group_brick_id'] as int,
            limit1: true),
      ))!
          .first,
      displayName: data['display_name'] as String,
      recurrenceRule: RecurrenceRule.fromJson(
          jsonDecode(data['recurrence_rule'] as String)
              as Map<String, dynamic>),
      startDate: DateTime.parse(data['start_date'] as String),
      timezone: data['timezone'] as String)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ScheduleToSqlite(Schedule instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'group_Group_brick_id': instance.group.primaryKey ??
        await provider.upsert<Group>(instance.group, repository: repository),
    'display_name': instance.displayName,
    'recurrence_rule': jsonEncode(instance.recurrenceRule.toJson()),
    'start_date': instance.startDate.toIso8601String(),
    'timezone': instance.timezone
  };
}

/// Construct a [Schedule]
class ScheduleAdapter extends OfflineFirstWithSupabaseAdapter<Schedule> {
  ScheduleAdapter();

  @override
  final supabaseTableName = 'schedules';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'group': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'group',
      associationType: Group,
      associationIsNullable: false,
      foreignKey: 'group_id',
    ),
    'groupId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
    ),
    'displayName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'display_name',
    ),
    'recurrenceRule': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recurrence_rule',
    ),
    'startDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'start_date',
    ),
    'timezone': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'timezone',
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
    'group': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'group_Group_brick_id',
      iterable: false,
      type: Group,
    ),
    'displayName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'display_name',
      iterable: false,
      type: String,
    ),
    'recurrenceRule': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'recurrence_rule',
      iterable: false,
      type: Map,
    ),
    'startDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'start_date',
      iterable: false,
      type: DateTime,
    ),
    'timezone': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'timezone',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Schedule instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Schedule` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Schedule';

  @override
  Future<Schedule> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ScheduleFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Schedule input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ScheduleToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Schedule> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ScheduleFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Schedule input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ScheduleToSqlite(input,
          provider: provider, repository: repository);
}
