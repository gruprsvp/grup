import 'package:parousia/models/models.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';

RemoteEntityState<Member> membersSelector(RootState state) => state.members;

RemoteEntityState<Profile> profilesSelector(RootState state) => state.profiles;

Iterable<Member> groupMembersSelector(RootState state, String groupId) {
  final id = int.parse(groupId);
  return membersSelector(state)
      .entities
      .values
      .where((member) => member.groupId == id);
}

Iterable<(Member, Profile?)> groupMembersWithProfilesSelector(
    RootState state, String groupId) {
  final members = groupMembersSelector(state, groupId);
  final profiles = profilesSelector(state).entities;
  return members.map((member) => (member, profiles[member.profileId]));
}
