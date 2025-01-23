import 'package:parousia/actions/actions.dart';
import 'package:parousia/brick/brick.dart';
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
                .upsertReply(action.entity)
                .then<dynamic>((reply) => SuccessUpdateOne(reply))
                .catchError((error) =>
                    FailUpdateOne<Reply>(entity: action.entity, error: error)),
          );
}

/// Delete a reply
Epic<AppState> _createRequestDeleteReplyEpic(RepliesRepository replies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteReplyAction>().asyncMap(
        (action) {
          print("state: ${store.state}");
          final reply = action.reply;
          final replyId = reply.id;
          final scheduleId = reply.schedule.id;
          final instanceDate = reply.instanceDate;
          final memberId = reply.member.id;
          if (replyId == null) {
            return FailDeleteOne<Reply>(
                id: "$memberId-$scheduleId-$instanceDate", error: "No ID");
          }
          return replies
              .deleteReply(reply: action.reply)
              .then<dynamic>((_) => SuccessDeleteOne<Reply>(replyId))
              .catchError(
                  (error) => FailDeleteOne<Reply>(id: replyId, error: error));
        },
      );
}
