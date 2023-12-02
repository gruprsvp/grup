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

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.members.name);
}
