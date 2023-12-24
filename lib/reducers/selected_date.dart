import 'package:parousia/actions/actions.dart';
import 'package:redux/redux.dart';

final selectedDateReducer = combineReducers<DateTime>([
  TypedReducer<DateTime, SelectDateAction>(_changeDate).call,
]);

DateTime _changeDate(DateTime currentDate, SelectDateAction action) {
  return action.date;
}
