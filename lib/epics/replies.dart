import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createRepliesEpics(RepliesRepository replies) => combineEpics<RootState>([
      _createRetrieveGroupRepliesEpic(replies),
      // _createCreateOneScheduleEpic(schedules),
    ]);

/// Fetch replies for a group
Epic<RootState> _createRetrieveGroupRepliesEpic(RepliesRepository replies) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<GroupDetailsOpenAction>().asyncMap(
            (action) => replies
                .getRepliesForDateRange(int.parse(action.groupId),
                    store.state.selectedDate.getNdayRange(1))
                .then<dynamic>((replies) =>
                    SuccessRetrieveAll(replies.toList(growable: false)))
                // TODO It seems this is not implemented in redux_entity
                // SuccessRetrieveMany<Schedule>(schedules.toList()))
                .catchError((error) => FailRetrieveMany<Reply>([], error)),
          );
}
