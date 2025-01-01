part of 'selectors.dart';

RemoteEntityState<Member> membersSelector(AppState state) => state.members;

String? selectGroupId(AppState state) => state.selectedGroupId;

final groupMembersSelector = createSelector2(
    membersSelector,
    selectGroupId,
    (members, groupId) => members.entities.values
        .where((member) => member.groupId.toString() == groupId)
        .sorted((a, b) => b.id.compareTo(a.id)));

final groupMembersWithProfilesSelector = createSelector2(
    groupMembersSelector,
    profilesSelector,
    (members, profiles) =>
        members.map((member) => (member, profiles.entities[member.profileId])));

final selectMyMember = createSelector2(
    groupMembersWithProfilesSelector,
    selectAuthUserId,
    (members, userId) =>
        members.firstWhereOrNull((m) => m.$1.profileId == userId));

final selectIsAdmin =
    createSelector1(selectMyMember, (m) => m?.$1.role == GroupRoles.admin);
