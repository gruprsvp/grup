// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<DefaultReply> _$DefaultReplyFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return DefaultReply(
      member: await MemberAdapter().fromSupabase(data['member'],
          provider: provider, repository: repository),
      schedule: await ScheduleAdapter().fromSupabase(data['schedule'],
          provider: provider, repository: repository),
      selectedOption: ReplyOptions.values[data['selected_option'] as int],
      recurrenceRule: RecurrenceRule.fromJson(
          data['recurrence_rule'] as Map<String, dynamic>),
      createdAt: data['created_at'] == null
          ? null
          : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.tryParse(data['updated_at'] as String));
}

Future<Map<String, dynamic>> _$DefaultReplyToSupabase(DefaultReply instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'member': await MemberAdapter().toSupabase(instance.member,
        provider: provider, repository: repository),
    'schedule': await ScheduleAdapter().toSupabase(instance.schedule,
        provider: provider, repository: repository),
    'selected_option': ReplyOptions.values.indexOf(instance.selectedOption),
    'recurrence_rule': instance.recurrenceRule.toJson(),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

Future<DefaultReply> _$DefaultReplyFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return DefaultReply(
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
      selectedOption: ReplyOptions.values[data['selected_option'] as int],
      recurrenceRule: RecurrenceRule.fromJson(
          jsonDecode(data['recurrence_rule'] as String)
              as Map<String, dynamic>),
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

Future<Map<String, dynamic>> _$DefaultReplyToSqlite(DefaultReply instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'member_Member_brick_id': instance.member.primaryKey ??
        await provider.upsert<Member>(instance.member, repository: repository),
    'schedule_Schedule_brick_id': instance.schedule.primaryKey ??
        await provider.upsert<Schedule>(instance.schedule,
            repository: repository),
    'selected_option': ReplyOptions.values.indexOf(instance.selectedOption),
    'recurrence_rule': jsonEncode(instance.recurrenceRule.toJson()),
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

/// Construct a [DefaultReply]
class DefaultReplyAdapter
    extends OfflineFirstWithSupabaseAdapter<DefaultReply> {
  DefaultReplyAdapter();

  @override
  final supabaseTableName = 'default_replies';
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
    'selectedOption': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'selected_option',
    ),
    'recurrenceRule': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'recurrence_rule',
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
          DefaultReply instance, DatabaseExecutor executor) async =>
      instance.primaryKey;
  @override
  final String tableName = 'DefaultReply';

  @override
  Future<DefaultReply> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultReplyFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(DefaultReply input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultReplyToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<DefaultReply> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultReplyFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(DefaultReply input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$DefaultReplyToSqlite(input,
          provider: provider, repository: repository);
}
