import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, AuthStateChangedAction>(_authStateChanged).call,
]);

AuthState _authStateChanged(
    AuthState authState, AuthStateChangedAction action) {
  final user = action.authState.session?.user;
  if (user != null) {
    return authState.copyWith(
      status: AuthStatus.authenticated,
      user: user,
    );
  }

  return authState;
}
