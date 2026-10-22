import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Who is signed in.
///
/// Notifies only when the signed-in user changes (sign-in, sign-out, a
/// different account), not on token refreshes or profile updates: the router
/// re-runs its redirects on every notification.
class AuthRepository extends ChangeNotifier {
  AuthRepository(this._auth) : _userId = _auth.currentUser?.id {
    _subscription = _auth.onAuthStateChange.listen(
      (state) => _setUser(state.session?.user.id),
      // A failed token refresh is reported here; the session event that
      // follows it (if any) is what matters.
      onError: (Object _) {},
    );
  }

  final GoTrueClient _auth;
  late final StreamSubscription<AuthState> _subscription;
  String? _userId;

  /// The signed-in user's id, or `null` when signed out.
  String? get userId => _userId;

  bool get isAuthenticated => _userId != null;

  /// Signs out on this device only.
  Future<Result<void>> signOut() => guard(_auth.signOut);

  void _setUser(String? userId) {
    if (userId == _userId) return;
    _userId = userId;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
