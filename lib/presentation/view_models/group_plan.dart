import 'dart:async';

import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import 'view_model.dart';

/// A group's plan: what it may do and why, its seats, and (on the web, for
/// admins) buying a plan or managing the one they pay for.
class GroupPlanViewModel extends ViewModel {
  GroupPlanViewModel({
    required this.groupId,
    required this._groups,
    required this._billing,
    bool checkoutSuccess = false,
  }) {
    load = Command0(_load)..execute();
    subscribe = Command1(
      (choice) => _billing.checkout(
        groupId: groupId,
        plan: choice.plan,
        interval: choice.interval,
      ),
    );
    manage = Command0(() => _billing.portal('/groups/$groupId/plan'));
    listenTo([_groups, _billing], _update);
    listenTo([load, subscribe, manage]);
    if (checkoutSuccess) _waitForActivation();
  }

  /// How often, and how long, the page asks whether a payment went through.
  static const pollEvery = Duration(seconds: 3);
  static const pollFor = Duration(seconds: 60);

  final String groupId;
  final GroupsRepository _groups;
  final BillingRepository _billing;

  Timer? _poll;
  bool _activating = false;
  bool _activationSlow = false;
  bool _activated = false;

  late final Command0<void> load;

  /// Opens Stripe Checkout for a plan: its URL, for the view to open.
  late final Command1<Uri, ({String plan, String interval})> subscribe;

  /// Opens Stripe's Customer Portal for the payer: its URL.
  late final Command0<Uri> manage;

  Group? get group => _groups.group(groupId);

  GroupAccess get access => _billing.access(groupId);

  BillingState get billing => _billing.state;

  /// Whether the user pays for the group's plan.
  bool get isPayer =>
      access.subscription?.payer != null &&
      access.subscription?.payer == _groups.userId;

  /// Back from Checkout, the plan is on its way: Stripe tells the server.
  bool get activating => _activating;

  /// It's taking longer than it should.
  bool get activationSlow => _activationSlow;

  /// Back from Checkout, the plan switched on while the page waited.
  bool get activated => _activated;

  /// The name of [userId], a member of this group or one of the user's.
  String? nameOf(String? userId) => _groups.profile(userId)?.displayName;

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _billing.refresh(),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  void _waitForActivation() {
    _activating = true;
    _poll = Timer.periodic(pollEvery, (timer) {
      if (pollEvery * timer.tick >= pollFor) {
        timer.cancel();
        _activationSlow = true;
        notifyListeners();
        return;
      }
      _billing.refresh();
    });
  }

  void _update() {
    if (_activating && access.subscription != null) {
      _activating = false;
      _activationSlow = false;
      _activated = true;
      _poll?.cancel();
      track('plan activated');
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}
