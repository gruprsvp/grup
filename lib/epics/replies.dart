import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createRepliesEpics(RepliesRepository replies) => combineEpics<AppState>([
      _createRetrieveGroupRepliesEpic(replies),
      _createRequestUpdateOneReplyEpic(replies),
      _createRequestDeleteReplyEpic(replies),
    ]);

/// Fetch replies for a group
Epic<AppState> _createRetrieveGroupRepliesEpic(RepliesRepository replies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<GroupDetailsOpenAction>().asyncMap(
            (action) => replies
                .getRepliesForDateRange(
                    action.groupId, store.state.selectedDate.getNdayRange(1))
                .then<dynamic>((replies) =>
                    SuccessRetrieveMany(replies.toList(growable: false)))
                .catchError((error) => FailRetrieveMany<Reply>([], error)),
          );
}

/// Create a new reply
Epic<AppState> _createRequestUpdateOneReplyEpic(RepliesRepository replies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestUpdateOne<Reply>>().asyncMap(
            (action) => replies
                .createReply(action.entity)
                .then<dynamic>((reply) => SuccessUpdateOne(reply))
                .catchError((error) =>
                    FailUpdateOne<Reply>(entity: action.entity, error: error)),
          );
}

/// Delete a reply
Epic<AppState> _createRequestDeleteReplyEpic(RepliesRepository replies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteReplyAction>().asyncMap(
            (action) => replies
                .deleteReply(
                  memberId: action.memberId,
                  scheduleId: action.scheduleId,
                  instanceDate: action.instanceDate,
                )
                .then<dynamic>((_) => SuccessDeleteOne<Reply>(
                    "${action.memberId}-${action.scheduleId}-${action.instanceDate}"))
                .catchError((error) => FailDeleteOne<Reply>(
                    id: "${action.memberId}-${action.scheduleId}-${action.instanceDate}",
                    error: error)),
          );
}
