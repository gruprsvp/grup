// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Group> _$GroupFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Group(
      id: data['id'] as String?,
      displayName: data['display_name'] as String,
      description:
          data['description'] == null ? null : data['description'] as String?,
      picture: data['picture'] == null ? null : data['picture'] as String?);
}

Future<Map<String, dynamic>> _$GroupToSupabase(Group instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'display_name': instance.displayName,
    'description': instance.description,
    'picture': instance.picture
  };
}

Future<Group> _$GroupFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Group(
      id: data['id'] as String,
      displayName: data['display_name'] as String,
      description:
          data['description'] == null ? null : data['description'] as String?,
      picture: data['picture'] == null ? null : data['picture'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$GroupToSqlite(Group instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'display_name': instance.displayName,
    'description': instance.description,
    'picture': instance.picture
  };
}

/// Construct a [Group]
class GroupAdapter extends OfflineFirstWithSupabaseAdapter<Group> {
  GroupAdapter();

  @override
  final supabaseTableName = 'groups';
  @override
  final defaultToNull = true;
  @override
  final fieldsToSupabaseColumns = {
    'id': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'id',
    ),
    'displayName': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'display_name',
    ),
    'description': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'description',
    ),
    'picture': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'picture',
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
    'displayName': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'display_name',
      iterable: false,
      type: String,
    ),
    'description': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'description',
      iterable: false,
      type: String,
    ),
    'picture': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'picture',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Group instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Group` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Group';

  @override
  Future<Group> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$GroupFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Group input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$GroupToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Group> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$GroupFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Group input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$GroupToSqlite(input, provider: provider, repository: repository);
}
