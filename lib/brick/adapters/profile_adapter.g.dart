// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Profile> _$ProfileFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Profile(
      id: data['id'] as String,
      displayName:
          data['display_name'] == null ? null : data['display_name'] as String?,
      picture: data['picture'] == null ? null : data['picture'] as String?);
}

Future<Map<String, dynamic>> _$ProfileToSupabase(Profile instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'display_name': instance.displayName,
    'picture': instance.picture
  };
}

Future<Profile> _$ProfileFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Profile(
      id: data['id'] as String,
      displayName:
          data['display_name'] == null ? null : data['display_name'] as String?,
      picture: data['picture'] == null ? null : data['picture'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$ProfileToSqlite(Profile instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'display_name': instance.displayName,
    'picture': instance.picture
  };
}

/// Construct a [Profile]
class ProfileAdapter extends OfflineFirstWithSupabaseAdapter<Profile> {
  ProfileAdapter();

  @override
  final supabaseTableName = 'profiles';
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
    'picture': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'picture',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Profile instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Profile` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Profile';

  @override
  Future<Profile> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProfileFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Profile input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProfileToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Profile> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProfileFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Profile input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$ProfileToSqlite(input,
          provider: provider, repository: repository);
}
