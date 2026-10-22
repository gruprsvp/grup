part of 'selectors.dart';

Iterable<Schedule> selectScheduleEntities(AppState state) =>
    state.schedules.entities.values;

final selectSchedulesIds = createSelector1(
  selectSchedules,
  (schedules) => schedules.map((s) => s.id),
);
