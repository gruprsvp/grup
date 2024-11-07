import 'package:parousia/models/models.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';

RemoteEntityState<Member> membersSelector(AppState state) => state.members;

RemoteEntityState<Profile> profilesSelector(AppState state) => state.profiles;

Iterable<Member> groupMembersSelector(AppState state, String groupId) {
  final id = int.parse(groupId);
  return membersSelector(state)
      .entities
      .values
      .where((member) => member.groupId == id);
}

Iterable<(Member, Profile?)> groupMembersWithProfilesSelector(
    AppState state, String groupId) {
  final members = groupMembersSelector(state, groupId);
  final profiles = profilesSelector(state).entities;
  return members.map((member) => (member, profiles[member.profileId]));
}

bool selectIsAdmin(AppState state, int groupId) {
  return state.members.entities.values
          .where((member) =>
              member.groupId == groupId &&
              member.profileId == state.auth.user?.id)
          .firstOrNull
          ?.role ==
      GroupRoles.admin;
}
