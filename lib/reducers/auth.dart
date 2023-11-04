import 'package:parousia/actions/actions.dart';
import 'package:parousia/state/state.dart';
import 'package:redux/redux.dart';
import 'package:supabase/supabase.dart' show AuthChangeEvent;

final authReducer = combineReducers<AuthState>([
  TypedReducer<AuthState, AuthStateChangedAction>(_authStateChanged).call,
]);

AuthState _authStateChanged(
    AuthState authState, AuthStateChangedAction action) {
  final user = action.authState.session?.user;
  if (action.authState.event == AuthChangeEvent.signedIn) {
    return authState.copyWith(
      status: AuthStatus.authenticated,
      user: user,
    );
  }

  if (action.authState.event == AuthChangeEvent.signedOut) {
    return authState.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
    );
  }

  return authState;
}
