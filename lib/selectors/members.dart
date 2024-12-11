import 'package:collection/collection.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:reselect/reselect.dart';

RemoteEntityState<Member> membersSelector(AppState state) => state.members;

RemoteEntityState<Profile> profilesSelector(AppState state) => state.profiles;

String? selectGroupId(AppState state) => state.selectedGroupId;

String? selectAuthUserId(AppState state) => state.auth.user?.id;

final groupMembersSelector = createSelector2(
    membersSelector,
    selectGroupId,
    (members, groupId) => members.entities.values
        .where((member) => member.group.id.toString() == groupId)
        .sorted((a, b) => b.id.compareTo(a.id)));

final groupMembersWithProfilesSelector = createSelector2(
    groupMembersSelector,
    profilesSelector,
    (members, profiles) => members
        .map((member) => (member, profiles.entities[member.profile?.id])));

final selectMyMember = createSelector2(
    groupMembersWithProfilesSelector,
    selectAuthUserId,
    (members, userId) =>
        members.firstWhereOrNull((m) => m.$1.profile?.id == userId));

final selectIsAdmin =
    createSelector1(selectMyMember, (m) => m?.$1.role == GroupRoles.admin);
