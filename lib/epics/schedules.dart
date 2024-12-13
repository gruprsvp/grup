import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createSchedulesEpics(SchedulesRepository schedules) => combineEpics<AppState>([
      _createRetrieveGroupSchedulesEpic(schedules),
      _createCreateOneScheduleEpic(schedules),
      _createDeleteOneScheduleEpic(schedules),
    ]);

/// Fetch all schedules for a group
Epic<AppState> _createRetrieveGroupSchedulesEpic(
    SchedulesRepository schedules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<GroupDetailsOpenAction>().asyncMap(
            (action) => schedules
                .getGroupSchedules(action.groupId)
                .then<dynamic>((schedules) =>
                    SuccessRetrieveMany(schedules.toList(growable: false)))
                .catchError((error) => FailRetrieveMany<Schedule>([], error)),
          );
}

/// When the user requests to create a new schedule
Epic<AppState> _createCreateOneScheduleEpic(SchedulesRepository schedules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) => actions
      .whereType<RequestCreateOne<Schedule>>()
      .asyncMap(
        (action) => schedules
            .createSchedule(action.entity)
            .then<dynamic>((schedule) => SuccessCreateOne<Schedule>(schedule))
            .catchError((error) =>
                FailCreateOne<Schedule>(entity: action.entity, error: error)),
      );
}

/// When the user requests to delete one schedule
Epic<AppState> _createDeleteOneScheduleEpic(SchedulesRepository schedules) {
  return (Stream<dynamic> actions, EpicStore<AppState> store) =>
      actions.whereType<RequestDeleteOne<Schedule>>().asyncMap(
            (action) => schedules
                .deleteSchedule(action.id)
                .then<dynamic>((_) => SuccessDeleteOne<Schedule>(action.id))
                .catchError((error) =>
                    FailDeleteOne<Schedule>(id: action.id, error: error)),
          );
}
