import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createMembersEpic(MembersRepository members) => combineEpics<AppState>([
      _createAddMembersToGroupEpic(members),
      _createUpdateMemberEpic(members),
      _onNewMembersCreated,
      _createRetrieveOwnMemberByGroupIdEpic(members),
      _createDeleteOneMember(members),
      _createRetrieveMembersByGroupIdEpic(members),
    ]);

Epic<AppState> _createAddMembersToGroupEpic(MembersRepository members) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<InviteGroupMembersAction>().asyncMap((action) async {
        final createMembersPromise = [
          for (final contact in action.contacts)
            (() async => (
                  await members.addMemberToGroup(action.group,
                      displayName: contact.displayNameOverride),
                  contact
                ))()
        ];

        final allMembers = await Future.wait(createMembersPromise);

        return NewMembersCreatedAction(allMembers);
      });
}

Epic<AppState> _createUpdateMemberEpic(MembersRepository members) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestUpdateOne<Member>>().asyncMap(
            (action) => members
                .updateMember(action.entity)
                .then<dynamic>((member) => SuccessUpdateOne<Member>(member))
                .onError((error, stackTrace) =>
                    FailUpdateOne<Member>(entity: action.entity, error: error)),
          );
}

Stream<dynamic> _onNewMembersCreated(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<NewMembersCreatedAction>()
        .map((action) => SuccessCreateMany<Member>(action.members
            .map(
              (e) => e.$1,
            )
            .toList()));

Epic<AppState> _createRetrieveOwnMemberByGroupIdEpic(
    MembersRepository members) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<SuccessCreateOne<Group>>().asyncMap((action) {
        final group = action.entity;
        return members
            .getOwnMemberByGroupId(group.id)
            .then<dynamic>((member) => SuccessRetrieveOne(member))
            .catchError((error) => FailRetrieveOne(id: group.id, error: error));
      });
}

Epic<AppState> _createRetrieveMembersByGroupIdEpic(MembersRepository members) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<SuccessRetrieveOne<Group>>().asyncMap((action) {
        final groupId = action.entity.id;
        return members
            .getMembersByGroupId(groupId)
            .then<dynamic>(
                (members) => SuccessRetrieveMany<Member>(members.toList()))
            .catchError((error) => FailRetrieveOne(id: groupId, error: error));
      });
}

Epic<AppState> _createDeleteOneMember(MembersRepository members) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteMemberAction>().asyncMap((action) {
        return members
            .deleteMember(action.member)
            .then<dynamic>((_) => SuccessDeleteOne<Member>(action.member.id))
            .catchError((error) =>
                FailDeleteOne<Member>(id: action.member.id, error: error));
      });
}
