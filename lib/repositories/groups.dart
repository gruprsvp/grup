import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

class GroupsRepository extends SupabaseRepository with Postgrest {
  GroupsRepository({required super.supabase}) : super(tableName: Tables.groups);

  Future<Iterable<Group>> getUserGroups() async {
    return table()
        .select('*, members!inner(*)')
        // TODO(borgoat): should filter by profile_id but return all members
        // .eq('members.profile_id', supabase.auth.currentUser!.id)
        .withConverter((data) => data.map(Group.fromJson));
  }

  Future<Group> getGroupById(int id) async {
    return table()
        .select('*, members!inner(*)')
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
    return table()
        .update({
          'display_name': group.displayName,
          'description': group.description,
          'picture': group.picture,
        })
        .eq('id', group.id)
        .select('*, members!inner(*)')
        .single()
        .withConverter(Group.fromJson);
  }

  Future<Group> deleteGroup(int id) async {
    return table()
        .delete()
        .eq('id', id)
        .select()
        .single()
        .withConverter(Group.fromJson);
  }
}
