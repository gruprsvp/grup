import 'package:parousia/actions/actions.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createInvitesEpics(InvitesRepository invites) => combineEpics<AppState>([
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
