import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupPlanContainer extends StatelessWidget {
  const GroupPlanContainer({
    super.key,
    required this.groupId,
    this.checkoutSuccess = false,
  });

  final String groupId;

  /// Stripe Checkout sent the admin back here after paying.
  final bool checkoutSuccess;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupPlanViewModel(
      groupId: groupId,
      groups: context.read(),
      billing: context.read(),
      checkoutSuccess: checkoutSuccess,
    ),
    child: Consumer<GroupPlanViewModel>(
      builder: (context, vm, _) => GroupPlanScreen(
        group: vm.group,
        access: vm.access,
        loading: vm.load.running,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onRefresh: vm.load.execute,
        isFounder: vm.billing.isFounder,
        isPayer: vm.isPayer,
        catalog: vm.billing.catalog,
        nameOf: vm.nameOf,
        activating: vm.activating,
        activationSlow: vm.activationSlow,
        celebrate: vm.activated,
        opening: vm.subscribe.running,
        onSubscribe: vm.subscribe.running
            ? null
            : (plan, interval) async {
                await vm.subscribe.execute((plan: plan, interval: interval));
                if (context.mounted) {
                  await openBillingPage(context, vm.subscribe.result);
                }
              },
        onManageBilling: vm.manage.running
            ? null
            : () async {
                await vm.manage.execute();
                if (context.mounted) {
                  await openBillingPage(context, vm.manage.result);
                }
              },
        // Encoded by hand, as in the feedback card: Uri writes spaces as '+'.
        onContact: () => launchUrl(
          Uri.parse(
            'mailto:hello@grup.rsvp?subject=${Uri.encodeComponent('GRUP for a big group')}',
          ),
        ),
      ),
    ),
  );
}

/// Opens a Stripe page in this tab: it comes back to the app when done. Or
/// says why there is none.
Future<void> openBillingPage(BuildContext context, Result<Uri>? result) async {
  switch (result) {
    case Ok(value: final url):
      await launchUrl(url, webOnlyWindowName: '_self');
    case _:
      showFailure(context, result);
  }
}
