import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createInvitesEpics(InvitesRepository invites) => combineEpics<AppState>([
      _createCreateInvitesOnNewMembersCreatedEpic(invites),
      _createGetInvitesForMemberEpic(invites),
      _createUseDeeplinkInviteCodeEpic(invites),
      _createUseInviteCodeEpic(invites),
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
            invites.inviteWithGeneratedCode(member.$1),
          for (final member in action.members)
            for (final invite in member.$2.invites)
              invites.inviteMember(Invite(
                  member: member.$1, method: invite.$1, value: invite.$2))
        ];

        final allInvites = await Future.wait(createInvitesPromise);
        return SuccessCreateMany<Invite>(allInvites);
      });
}

Epic<AppState> _createGetInvitesForMemberEpic(InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<MemberDetailsOpenAction>()
      .asyncMap((action) => invites
          .getInvitesForMember(action.memberId)
          .then<dynamic>((invites) =>
              SuccessRetrieveMany<Invite>(invites.toList(growable: false)))
          .catchError((error) => FailRetrieveMany<Invite>([], error)));
}

Epic<AppState> _createUseDeeplinkInviteCodeEpic(InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
          .whereType<HandleDeeplinkAction>()
          .where((action) =>
              action.paths.isNotEmpty && action.paths.first == 'join')
          .asyncMap((action) {
        final code = action.paths.last;
        return invites
            .consumeInviteCode(code)
            .then<dynamic>((_) => const SuccessUseInviteCode())
            .onError((error, stackTrace) => FailUseInviteCode(error));
      });
}
