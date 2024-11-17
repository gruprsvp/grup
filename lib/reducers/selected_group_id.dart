import 'package:parousia/actions/actions.dart';
import 'package:redux/redux.dart';

final selectedGroupIdReducer = combineReducers<String?>([
  TypedReducer<String?, GroupDetailsOpenAction>(_changeGroup).call,
]);

String _changeGroup(String? currentGroupId, GroupDetailsOpenAction action) {
  return action.groupId;
}
