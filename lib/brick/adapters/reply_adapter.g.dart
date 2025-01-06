// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Reply> _$ReplyFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Reply(
      member: await MemberAdapter().fromSupabase(data['member'],
          provider: provider, repository: repository),
      schedule: await ScheduleAdapter().fromSupabase(data['schedule'],
          provider: provider, repository: repository),
      instanceDate: DateTime.parse(data['instance_date'] as String),
      selectedOption: ReplyOptions.values[data['selected_option'] as int],
      createdAt: data['created_at'] == null
          ? null
          : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.tryParse(data['updated_at'] as String));
}

Future<Map<String, dynamic>> _$ReplyToSupabase(Reply instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'member': await MemberAdapter().toSupabase(instance.member,
        provider: provider, repository: repository),
    'schedule': await ScheduleAdapter().toSupabase(instance.schedule,
        provider: provider, repository: repository),
    'instance_date': instance.instanceDate.toIso8601String(),
    'selected_option': ReplyOptions.values.indexOf(instance.selectedOption),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

Future<Reply> _$ReplyFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Reply(
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
      instanceDate: DateTime.parse(data['instance_date'] as String),
      selectedOption: ReplyOptions.values[data['selected_option'] as int],
      createdAt: data['created_at'] == null
          ? null
          : data['created_at'] == null
              ? null
              : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : data['updated_at'] == null
              ? null
              : DateTime.tryParse(data['updated_at'] as String))
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ReplyToSqlite(Reply instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'member_Member_brick_id': instance.member.primaryKey ??
        await provider.upsert<Member>(instance.member, repository: repository),
    'schedule_Schedule_brick_id': instance.schedule.primaryKey ??
        await provider.upsert<Schedule>(instance.schedule,
            repository: repository),
    'instance_date': instance.instanceDate.toIso8601String(),
    'selected_option': ReplyOptions.values.indexOf(instance.selectedOption),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

/// Construct a [Reply]
class ReplyAdapter extends OfflineFirstWithSupabaseAdapter<Reply> {
  ReplyAdapter();

  @override
  final supabaseTableName = 'replies';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
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
    'instanceDate': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'instance_date',
    ),
    'selectedOption': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'selected_option',
    ),
    'createdAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'created_at',
    ),
    'updatedAt': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'updated_at',
    )
  };
  @override
  final ignoreDuplicates = false;
  @override
  final uniqueFields = {};
  @override
  final Map<String, RuntimeSqliteColumnDefinition> fieldsToSqliteColumns = {
    'primaryKey': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: '_brick_id',
      iterable: false,
      type: int,
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
    'instanceDate': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'instance_date',
      iterable: false,
      type: DateTime,
    ),
    'selectedOption': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'selected_option',
      iterable: false,
      type: ReplyOptions,
    ),
    'createdAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'created_at',
      iterable: false,
      type: DateTime,
    ),
    'updatedAt': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'updated_at',
      iterable: false,
      type: DateTime,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Reply instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Reply` WHERE member_Member_brick_id = ? OR schedule_Schedule_brick_id = ? OR instance_date = ? LIMIT 1''',
        [instance.member, instance.schedule, instance.instanceDate]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Reply';

  @override
  Future<Reply> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReplyFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Reply input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReplyToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Reply> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReplyFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Reply input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ReplyToSqlite(input, provider: provider, repository: repository);
}
