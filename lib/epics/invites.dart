import 'package:parousia/actions/actions.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createInvitesEpics(InvitesRepository invites) => combineEpics<RootState>([
      _createUseInviteCodeEpic(invites),
    ]);

Epic<RootState> _createUseInviteCodeEpic(InvitesRepository invites) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<JoinWithInviteCodeAction>().asyncMap(
            (action) => invites
                .consumeInviteCode(action.code)
                .then<dynamic>((_) => const SuccessUseInviteCode())
                .catchError((error) => FailUseInviteCode(error)),
          );
}
