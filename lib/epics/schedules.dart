import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/state/state.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

createSchedulesEpics(SchedulesRepository schedules) => combineEpics<RootState>([
      _createRetrieveGroupSchedulesEpic(schedules),
      _createCreateOneScheduleEpic(schedules),
    ]);

/// Fetch all schedules for a group
Epic<RootState> _createRetrieveGroupSchedulesEpic(
    SchedulesRepository schedules) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) =>
      actions.whereType<GroupDetailsOpenAction>().asyncMap(
            (action) => schedules
                .getGroupSchedules(int.parse(action.groupId))
                .then<dynamic>((schedules) =>
                    SuccessRetrieveMany(schedules.toList(growable: false)))
                .catchError((error) => FailRetrieveMany<Schedule>([], error)),
          );
}

Epic<RootState> _createCreateOneScheduleEpic(SchedulesRepository schedules) {
  return (Stream<dynamic> actions, EpicStore<RootState> store) => actions
      .whereType<RequestCreateOne<Schedule>>()
      .asyncMap(
        (action) => schedules
            .createSchedule(action.entity)
            .then<dynamic>((schedule) => SuccessCreateOne<Schedule>(schedule))
            .catchError((error) =>
                FailCreateOne<Schedule>(entity: action.entity, error: error)),
      );
}
