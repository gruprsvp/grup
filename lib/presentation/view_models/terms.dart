import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

import 'view_model.dart';

/// Accepting the terms in force; the router lets the user in once accepted.
class TermsViewModel extends ViewModel {
  TermsViewModel({
    required BillingRepository billing,
    required AuthRepository auth,
  }) {
    accept = Command0(billing.acceptTerms);
    signOut = Command0(auth.signOut);
    listenTo([accept, signOut]);
  }

  late final Command0<void> accept;

  /// For a user who doesn't accept.
  late final Command0<void> signOut;
}
