import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

typedef GroupsAndMembers = ({
  Iterable<Group> groups,
  Iterable<Member> members,
  Iterable<Profile> profiles,
});

class GroupsRepository extends SupabaseRepository with Postgrest {
  GroupsRepository({required super.supabase}) : super(tableName: Tables.groups);

  Future<Iterable<Group>> getUserGroups() async {
    return table()
        .select('*,members!inner(*,profiles!left(*))')
        // ! Trying to load all profiles in one shot will trigger an exception
        // ! https://github.com/appforit/appforit/issues/112
        .eq('members.profile_id', supabase.auth.currentUser!.id)
        .withConverter((data) => data.map(Group.fromJson));
  }

  Future<GroupsAndMembers> getGroupById(int id) async {
    return table()
        .select('*,members!inner(*,profiles!left(*))')
        .eq('id', id)
        .withConverter(_convertGroupsAndMembers);
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
        .select('*')
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

  GroupsAndMembers _convertGroupsAndMembers(List<Map<String, dynamic>> data) {
    final groups = <Group>{};
    final members = <Member>{};
    final profiles = <Profile>{};
    for (var value in data) {
      groups.add(Group.fromJson(value));
      if (value['members'] != null) {
        for (var member in value['members']) {
          members.add(Member.fromJson(member));
          if (member['profiles'] != null) {
            profiles.add(Profile.fromJson(member['profiles']));
          }
        }
      }
    }
    return (groups: groups, members: members, profiles: profiles);
  }
}
