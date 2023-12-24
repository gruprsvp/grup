import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createDefaultRepliesEpics(DefaultRepliesRepository defaultReplies) =>
    combineEpics<RootState>([
      _createRetrieveGroupDefaultRepliesEpic(defaultReplies),
      // _createCreateOneScheduleEpic(schedules),
    ]);

/// Fetch all default replies for a group
Epic<RootState> _createRetrieveGroupDefaultRepliesEpic(
    DefaultRepliesRepository defaultReplies) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<GroupDetailsOpenAction>()
      .asyncMap(
        (action) => defaultReplies
            .getDefaultReplies(int.parse(action.groupId))
            .then<dynamic>((defaultReplies) =>
                SuccessRetrieveAll(defaultReplies.toList(growable: false)))
            // TODO It seems this is not implemented in redux_entity
            // SuccessRetrieveMany<Schedule>(schedules.toList()))
            .catchError((error) => FailRetrieveMany<DefaultReply>([], error)),
      );
}
