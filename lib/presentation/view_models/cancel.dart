import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

import 'view_model.dart';

/// What the cancellation page sends.
typedef CancellationRequest = ({
  String action,
  String email,
  String? groupId,
  String? name,
  String language,
});

/// The public cancellation page: cancel or withdraw from plans by the paying
/// account's email address, signed in or not.
class CancelViewModel extends ViewModel {
  CancelViewModel({
    required this._auth,
    required this._billing,
    required this._groups,
  }) {
    submit = Command1(
      (CancellationRequest r) => _billing.requestCancellation(
        action: r.action,
        email: r.email,
        groupId: r.groupId,
        name: r.name,
        language: r.language,
      ),
    );
    listenTo([_billing, _groups, submit]);
  }

  final AuthRepository _auth;
  final BillingRepository _billing;
  final GroupsRepository _groups;

  late final Command1<void, CancellationRequest> submit;

  /// The signed-in user's address, to fill in.
  String? get email => _auth.email;

  /// The groups whose plan the signed-in user pays for, by id: to pick one.
  /// Empty when signed out.
  Map<String, String> get paidGroups => {
    for (final MapEntry(key: id, value: group) in _billing.state.groups.entries)
      if (group.sources.any(
        (s) => s.kind == 'subscription' && s.payer == _auth.userId,
      ))
        id: _groups.group(id)?.displayName ?? id,
  };
}
