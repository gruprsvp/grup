import 'package:parousia/actions/actions.dart';
import 'package:redux/redux.dart';

final selectedScheduleIdReducer = combineReducers<String?>([
  TypedReducer<String?, GroupScheduleDetailsOpenAction>(_changeSchedule).call,
]);

String _changeSchedule(
    String? currentScheduleId, GroupScheduleDetailsOpenAction action) {
  return action.scheduleId;
}
