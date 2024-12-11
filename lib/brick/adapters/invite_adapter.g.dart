// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Invite> _$InviteFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Invite(
      id: data['id'] as String?,
      member: await MemberAdapter().fromSupabase(data['member'],
          provider: provider, repository: repository),
      method: InviteMethods.values[data['method'] as int],
      value: data['value'] as String,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.tryParse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.tryParse(data['updated_at'] as String));
}

Future<Map<String, dynamic>> _$InviteToSupabase(Invite instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'member': await MemberAdapter().toSupabase(instance.member,
        provider: provider, repository: repository),
    'method': InviteMethods.values.indexOf(instance.method),
    'value': instance.value,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

Future<Invite> _$InviteFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Invite(
      id: data['id'] as String,
      member: (await repository!.getAssociation<Member>(
        Query.where('primaryKey', data['member_Member_brick_id'] as int,
            limit1: true),
      ))!
          .first,
      method: InviteMethods.values[data['method'] as int],
      value: data['value'] as String,
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

Future<Map<String, dynamic>> _$InviteToSqlite(Invite instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'member_Member_brick_id': instance.member.primaryKey ??
        await provider.upsert<Member>(instance.member, repository: repository),
    'method': InviteMethods.values.indexOf(instance.method),
    'value': instance.value,
    'created_at': instance.createdAt?.toIso8601String(),
    'updated_at': instance.updatedAt?.toIso8601String()
  };
}

/// Construct a [Invite]
class InviteAdapter extends OfflineFirstWithSupabaseAdapter<Invite> {
  InviteAdapter();

  @override
  final supabaseTableName = 'invites';
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
    'method': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'method',
    ),
    'value': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'value',
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
    'method': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'method',
      iterable: false,
      type: InviteMethods,
    ),
    'value': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'value',
      iterable: false,
      type: String,
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
      Invite instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Invite` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Invite';

  @override
  Future<Invite> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InviteFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Invite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InviteToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Invite> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InviteFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Invite input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$InviteToSqlite(input, provider: provider, repository: repository);
}
