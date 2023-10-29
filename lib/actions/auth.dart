import 'package:supabase/supabase.dart';

/// Action fired whenever the auth changed according to Supabase.
class AuthStateChangedAction {
  AuthStateChangedAction(this.authState);

  final AuthState authState;
}
