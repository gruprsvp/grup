import 'package:parousia/models/models.dart';

import 'supabase.dart';

/// Paid plans: the user's billing state, and Stripe's pages for the web.
class BillingService extends SupabaseService {
  const BillingService({required super.supabase});

  /// The mode, the user's groups' entitlements and the plans on sale.
  Future<BillingState> getBillingState() async => BillingState.fromJson(
    await supabase.rpc<Map<String, dynamic>>('billing_state'),
  );

  /// Stripe Checkout, where an admin buys [plan] for [groupId] by the
  /// [interval] (`month` or `year`).
  Future<Uri> checkout({
    required String groupId,
    required String plan,
    required String interval,
  }) => _url('billing-checkout', {
    'group_id': groupId,
    'plan': plan,
    'interval': interval,
  });

  /// Stripe's Customer Portal, which comes back to [returnPath] in the app.
  Future<Uri> portal({required String returnPath}) =>
      _url('billing-portal', {'return_path': returnPath});

  Future<Uri> _url(String function, Map<String, Object> body) async {
    final response = await supabase.functions.invoke(function, body: body);
    return Uri.parse((response.data as Map)['url'] as String);
  }
}
