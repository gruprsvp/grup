import 'package:flutter/foundation.dart';
import 'package:supabase/supabase.dart';

/// Action fired whenever the auth changed according to Supabase.
@immutable
class AuthStateChangedAction {
  AuthStateChangedAction(this.authState);

  final AuthState authState;
}
