import 'package:parousia/models/models.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

import 'user_data.dart';

/// Paid plans as the server sees them for the signed-in user: the mode, what
/// each of their groups may do, and the plans on sale
/// (docs/billing-and-entitlements.md).
class BillingRepository extends UserData {
  BillingRepository({required this._billing, required LocalCache cache})
    : super(cache, cacheKey);

  /// Where the device copy lives in [LocalCache].
  static const cacheKey = 'billing';

  final BillingService _billing;

  BillingState _state = const BillingState();

  BillingState get state => _state;

  /// What [groupId] may do on this platform.
  GroupAccess access(String groupId) => GroupAccess.of(_state, groupId);

  /// Reloads the billing state. Pages call it when they load their groups:
  /// a failure only leaves the last state in place.
  Future<Result<void>> refresh() {
    final generation = this.generation;
    return guard(() async {
      final state = await _billing.getBillingState();
      ifCurrent(generation, () => _state = state);
    });
  }

  @override
  void clear() => _state = const BillingState();

  @override
  Map<String, dynamic> toCache() => _state.toJson();

  @override
  void fromCache(Map<String, dynamic> json) =>
      _state = BillingState.fromJson(json);
}
