import 'package:parousia/models/models.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class MembersRepository extends SupabaseRepository with Postgrest {
  const MembersRepository({required super.supabase})
      : super(tableName: Tables.members);

  Future<Member> addMemberToGroup(String groupId,
      {String? displayName, String? profileId}) async {
    if ((displayName == null || displayName.isEmpty) &&
        (profileId == null || profileId.isEmpty)) {
      throw ArgumentError(
          'Either displayName or profileId must be provided to addMemberToGroup');
    }

    return table()
        .insert({
          'id': const Uuid().v7(),
          'group_id': groupId,
          'profile_id': profileId,
          'display_name_override': displayName,
        })
        .select()
        .single()
        .withConverter((data) => Member.fromJson(data));
  }

  Future<Member> updateMember(
      {required String memberId,
      String? displayNameOverride,
      GroupRoles? role}) async {
    return table()
        .update({
          if (displayNameOverride != null && displayNameOverride.isNotEmpty)
            'display_name_override': displayNameOverride,
          if (role != null) 'role': role.name,
        })
        .eq('id', memberId)
        .select()
        .single()
        .withConverter(Member.fromJson);
  }

  Future<void> deleteMember(String memberId) async {
    return table().delete().eq('id', memberId);
  }

  Future<Member> getOwnMemberByGroupId(String groupId) async {
    return table()
        .select('*')
        .eq('group_id', groupId)
        .eq('profile_id', supabase.auth.currentUser!.id)
        .single()
        .withConverter(Member.fromJson);
  }
}
