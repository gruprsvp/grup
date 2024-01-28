import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createDefaultRepliesEpics(DefaultRepliesRepository defaultReplies) =>
    combineEpics<AppState>([
      _createRetrieveGroupDefaultRepliesEpic(defaultReplies),
      // _createCreateOneScheduleEpic(schedules),
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
