import 'package:parousia/models/models.dart';
import 'package:parousia/util/errors.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class MembersService extends SupabaseService with Postgrest {
  const MembersService({required super.supabase})
    : super(tableName: Tables.members);

  Future<Member> addMemberToGroup(
    String groupId, {
    String? displayName,
    String? profileId,
  }) async {
    if ((displayName == null || displayName.isEmpty) &&
        (profileId == null || profileId.isEmpty)) {
      throw ArgumentError(
        'Either displayName or profileId must be provided to addMemberToGroup',
      );
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

  Future<Member> updateMember({
    required String memberId,
    String? displayNameOverride,
    GroupRoles? role,
  }) async {
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

  // Selecting the deleted row makes a delete that matched nothing (already
  // gone, or hidden by row-level security) fail instead of looking done.
  Future<void> deleteMember(String memberId) async {
    await table().delete().eq('id', memberId).select('id').single();
  }

  Future<Member> getOwnMemberByGroupId(String groupId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw const NotSignedInException();
    return table()
        .select('*')
        .eq('group_id', groupId)
        .eq('profile_id', userId)
        .single()
        .withConverter(Member.fromJson);
  }
}
