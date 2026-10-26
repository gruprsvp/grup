import 'package:parousia/models/models.dart';

import 'supabase.dart';

/// Paid plans: the user's billing state.
class BillingService extends SupabaseService {
  const BillingService({required super.supabase});

  /// The mode, the user's groups' entitlements and the plans on sale.
  Future<BillingState> getBillingState() async => BillingState.fromJson(
    await supabase.rpc<Map<String, dynamic>>('billing_state'),
  );
}
