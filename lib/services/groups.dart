import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

typedef GroupsAndMembers = ({
  Iterable<Group> groups,
  Iterable<Member> members,
  Iterable<Profile> profiles,
});

class GroupsService extends SupabaseService with Postgrest {
  GroupsService({required super.supabase}) : super(tableName: Tables.groups);

  Future<GroupsAndMembers> getUserGroups() async {
    return table()
        .select('*,members!inner(*,profiles!left(*))')
        // TODO(borgoat): should filter by profile_id but return all members
        // .eq('members.profile_id', supabase.auth.currentUser!.id)
        .withConverter(_convertGroupsAndMembers);
  }

  /// The group with its members and their profiles.
  Future<GroupsAndMembers> getGroupById(String id) async {
    return table()
        .select('*,members!inner(*,profiles!left(*))')
        .eq('id', id)
        .single()
        .withConverter((data) => _convertGroupsAndMembers([data]));
  }

  Future<Group> createGroup(Group group) async {
    return supabase
        .rpc<PostgrestList>(
          'create_group',
          params: {
            'id': const Uuid().v7(),
            'display_name': group.displayName,
            'description': group.description,
            'picture': group.picture,
          },
        )
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

  Future<Group> deleteGroup(String id) async {
    return table()
        .delete()
        .eq('id', id)
        .select()
        .single()
        .withConverter(Group.fromJson);
  }

  GroupsAndMembers _convertGroupsAndMembers(List<Map<String, dynamic>> data) {
    final members = [
      for (final group in data)
        ...((group['members'] as List?) ?? const [])
            .cast<Map<String, dynamic>>(),
    ];
    return (
      groups: decodeRows(data, Group.fromJson),
      members: decodeRows(members, Member.fromJson),
      // A profile appears once per group its user is in: keep one of each.
      profiles: {
        for (final profile in decodeRows([
          for (final member in members)
            if (member['profiles'] case final Map<String, dynamic> profile)
              profile,
        ], Profile.fromJson))
          profile.id: profile,
      }.values,
    );
  }
}
