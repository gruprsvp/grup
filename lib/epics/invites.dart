import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createInvitesEpics(InvitesRepository invites) => combineEpics<AppState>([
      _createUseInviteCodeEpic(invites),
      _createCreateInvitesOnNewMembersCreatedEpic(invites),
      _createGetInvitesForMemberEpic(invites),
    ]);

Epic<AppState> _createUseInviteCodeEpic(InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<JoinWithInviteCodeAction>()
      .asyncMap((action) => invites
          .consumeInviteCode(action.code)
          .then<dynamic>((_) => const SuccessUseInviteCode())
          .onError((error, stackTrace) => FailUseInviteCode(error)));
}

Epic<AppState> _createCreateInvitesOnNewMembersCreatedEpic(
    InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<NewMembersCreatedAction>().asyncMap((action) async {
        final createInvitesPromise = [
          for (final member in action.members)
            invites.inviteWithGeneratedCode(member.$1.id),
          for (final member in action.members)
            for (final invite in member.$2.invites)
              invites.inviteMember(member.$1.id, invite.$1, invite.$2)
        ];

        final allInvites = await Future.wait(createInvitesPromise);
        return SuccessCreateMany<Invite>(allInvites);
      });
}

Epic<AppState> _createGetInvitesForMemberEpic(InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<MemberDetailsOpenAction>()
      .asyncMap((action) => invites
          .getInvitesForMember(int.parse(action.memberId))
          .then<dynamic>((invites) =>
              SuccessRetrieveMany<Invite>(invites.toList(growable: false)))
          .catchError((error) => FailRetrieveMany<Invite>([], error)));
}
