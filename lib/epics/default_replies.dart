import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createDefaultRepliesEpics(DefaultRepliesRepository defaultReplies) =>
    combineEpics<AppState>([
      _createRetrieveGroupDefaultRepliesEpic(defaultReplies),
      _createRequestUpdateOneDefaultReplyEpic(defaultReplies),
      _createRequestDeleteDefaultReplyEpic(defaultReplies),
    ]);

/// Fetch all default replies for a group
Epic<AppState> _createRetrieveGroupDefaultRepliesEpic(
    DefaultRepliesRepository defaultReplies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<GroupDetailsOpenAction>()
      .asyncMap(
        (action) => defaultReplies
            .getDefaultReplies(int.parse(action.groupId))
            .then<dynamic>((defaultReplies) =>
                SuccessRetrieveMany(defaultReplies.toList(growable: false)))
            .catchError((error) => FailRetrieveMany<DefaultReply>([], error)),
      );
}

/// Create a new default reply
Epic<AppState> _createRequestUpdateOneDefaultReplyEpic(
    DefaultRepliesRepository defaultReplies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestUpdateOne<DefaultReply>>().asyncMap(
            (action) => defaultReplies
                .createDefaultReply(action.entity)
                .then<dynamic>((defaultReply) => SuccessUpdateOne(defaultReply))
                .catchError((error) => FailUpdateOne<DefaultReply>(
                    entity: action.entity, error: error)),
          );
}

/// Delete a default reply
Epic<AppState> _createRequestDeleteDefaultReplyEpic(
    DefaultRepliesRepository defaultReplies) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteDefaultReplyAction>().asyncMap(
            (action) => defaultReplies
                .deleteDefaultReply(
                  memberId: action.memberId,
                  scheduleId: action.scheduleId,
                )
                .then<dynamic>((_) => SuccessDeleteOne<DefaultReply>(
                    "${action.memberId}-${action.scheduleId}"))
                .catchError((error) => FailDeleteOne<DefaultReply>(
                    id: "${action.memberId}-${action.scheduleId}",
                    error: error)),
          );
}
