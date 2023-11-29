import 'package:parousia/models/models.dart';
import 'package:supabase/supabase.dart';

import 'const.dart';

class GroupsRepository {
  GroupsRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Iterable<Group>> getUserGroups() async {
    return _table()
        .select<PostgrestList>('*, members!inner(*)')
        .eq('members.profile_id', supabase.auth.currentUser!.id)
        .withConverter((data) => data.map(Group.fromJson));
  }

  Future<Group> getGroupById(int id) async {
    return _table()
        .select<PostgrestMap>()
        .eq('id', id)
        .single()
        .withConverter(Group.fromJson);
  }

  Future<Group> createGroup(Group group) async {
    return supabase
        .rpc('create_group', params: {
          'display_name': group.displayName,
          'description': group.description,
          'picture': group.picture,
        })
        .single()
        .withConverter((data) => Group.fromJson(data));
  }

  Future<Group> updateGroup(Group group) async {
    return _table()
        .update({
          'display_name': group.displayName,
          'description': group.description,
          'picture': group.picture,
        })
        .eq('id', group.id)
        .select<PostgrestMap>()
        .single()
        .withConverter(Group.fromJson);
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.groups.name);
}
