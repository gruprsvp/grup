// GENERATED CODE DO NOT EDIT
part of '../brick.g.dart';

Future<Member> _$MemberFromSupabase(Map<String, dynamic> data,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Member(
      id: data['id'] as String?,
      group: await GroupAdapter().fromSupabase(data['group'],
          provider: provider, repository: repository),
      profile: data['profile'] == null
          ? null
          : await ProfileAdapter().fromSupabase(data['profile'],
              provider: provider, repository: repository),
      role: GroupRoles.values.byName(data['role']),
      displayNameOverride: data['display_name_override'] == null
          ? null
          : data['display_name_override'] as String?);
}

Future<Map<String, dynamic>> _$MemberToSupabase(Member instance,
    {required SupabaseProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'group_id': instance.groupId,
    'profile_id': instance.profileId,
    'role': instance.role.name,
    'display_name_override': instance.displayNameOverride
  };
}

Future<Member> _$MemberFromSqlite(Map<String, dynamic> data,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return Member(
      id: data['id'] as String,
      group: (await repository!.getAssociation<Group>(
        Query.where('primaryKey', data['group_Group_brick_id'] as int,
            limit1: true),
      ))!
          .first,
      profile: data['profile_Profile_brick_id'] == null
          ? null
          : (data['profile_Profile_brick_id'] > -1
              ? (await repository.getAssociation<Profile>(
                  Query.where(
                      'primaryKey', data['profile_Profile_brick_id'] as int,
                      limit1: true),
                ))
                  ?.first
              : null),
      role: GroupRoles.values[data['role'] as int],
      displayNameOverride: data['display_name_override'] == null
          ? null
          : data['display_name_override'] as String?)
    ..primaryKey = data['_brick_id'] as int;
}

Future<Map<String, dynamic>> _$MemberToSqlite(Member instance,
    {required SqliteProvider provider,
    OfflineFirstWithSupabaseRepository? repository}) async {
  return {
    'id': instance.id,
    'group_Group_brick_id': instance.group.primaryKey ??
        await provider.upsert<Group>(instance.group, repository: repository),
    'profile_Profile_brick_id': instance.profile != null
        ? instance.profile!.primaryKey ??
            await provider.upsert<Profile>(instance.profile!,
                repository: repository)
        : null,
    'role': GroupRoles.values.indexOf(instance.role),
    'display_name_override': instance.displayNameOverride
  };
}

/// Construct a [Member]
class MemberAdapter extends OfflineFirstWithSupabaseAdapter<Member> {
  MemberAdapter();

  @override
  final supabaseTableName = 'members';
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
    'profile': const RuntimeSupabaseColumnDefinition(
      association: true,
      columnName: 'profile',
      associationType: Profile,
      associationIsNullable: true,
      foreignKey: 'profile_id',
    ),
    'groupId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'group_id',
    ),
    'profileId': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'profile_id',
    ),
    'role': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'role',
    ),
    'displayNameOverride': const RuntimeSupabaseColumnDefinition(
      association: false,
      columnName: 'display_name_override',
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
    'profile': const RuntimeSqliteColumnDefinition(
      association: true,
      columnName: 'profile_Profile_brick_id',
      iterable: false,
      type: Profile,
    ),
    'role': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'role',
      iterable: false,
      type: GroupRoles,
    ),
    'displayNameOverride': const RuntimeSqliteColumnDefinition(
      association: false,
      columnName: 'display_name_override',
      iterable: false,
      type: String,
    )
  };
  @override
  Future<int?> primaryKeyByUniqueColumns(
      Member instance, DatabaseExecutor executor) async {
    final results = await executor.rawQuery('''
        SELECT * FROM `Member` WHERE id = ? LIMIT 1''', [instance.id]);

    // SQFlite returns [{}] when no results are found
    if (results.isEmpty || (results.length == 1 && results.first.isEmpty)) {
      return null;
    }

    return results.first['_brick_id'] as int;
  }

  @override
  final String tableName = 'Member';

  @override
  Future<Member> fromSupabase(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$MemberFromSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSupabase(Member input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$MemberToSupabase(input,
          provider: provider, repository: repository);
  @override
  Future<Member> fromSqlite(Map<String, dynamic> input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$MemberFromSqlite(input,
          provider: provider, repository: repository);
  @override
  Future<Map<String, dynamic>> toSqlite(Member input,
          {required provider,
          covariant OfflineFirstWithSupabaseRepository? repository}) async =>
      await _$MemberToSqlite(input, provider: provider, repository: repository);
}
