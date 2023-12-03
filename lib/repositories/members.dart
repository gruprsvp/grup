import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class MembersRepository {
  MembersRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Member> addMemberToGroup(int groupId,
      {String? displayName, String? profileId}) async {
    if ((displayName == null || displayName.isEmpty) &&
        (profileId == null || profileId.isEmpty)) {
      throw ArgumentError(
          'Either displayName or profileId must be provided to addMemberToGroup');
    }

    return _table()
        .insert({
          'group_id': groupId,
          'profile_id': profileId,
          'display_name_override': displayName,
        })
        .select()
        .single()
        .withConverter((data) => Member.fromJson(data));
  }

  Future<Member> updateMember(
      {required int memberId, required String displayNameOverride}) async {
    return _table()
        .update({
          'display_name_override': displayNameOverride,
        })
        .eq('id', memberId)
        .select<PostgrestMap>()
        .single()
        .withConverter(Member.fromJson);
  }

  Future<void> removeMember(int memberId) async {
    return _table().delete().eq('id', memberId);
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.members.name);
}
