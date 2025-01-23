import 'package:parousia/actions/actions.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:redux/redux.dart';
import 'package:redux_entity/redux_entity.dart';

import 'remote_entities.dart';

final combinedGroupsReducer = combineReducers([
  TypedReducer<RemoteEntityState<Group>, JoinWithInviteCodeAction>(
    (state, action) => state.copyWith(creating: true),
  ).call,
  TypedReducer<RemoteEntityState<Group>, SuccessUseInviteCode>(
    (state, action) => state.copyWith(creating: false),
  ).call,
  TypedReducer<RemoteEntityState<Group>, FailUseInviteCode>(
    (state, action) => state.copyWith(creating: false, error: action.error),
  ).call,
  groupsReducer.call,
]);
