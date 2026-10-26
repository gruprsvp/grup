import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class GroupKitchenContainer extends StatelessWidget {
  const GroupKitchenContainer({super.key, required this.groupId, this.date});

  final String groupId;

  /// The day to show; today without one.
  final DateTime? date;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupKitchenViewModel(
      groupId: groupId,
      groups: context.read(),
      schedules: context.read(),
      billing: context.read(),
      date: date,
    ),
    child: Consumer<GroupKitchenViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        String nameOf((Member, Profile?) member) =>
            member.$1.displayNameOverride ??
            member.$2?.displayName ??
            l10n.unknown;
        return GroupKitchenScreen(
          group: vm.group,
          available: vm.access.show(FeatureKey.kitchenView),
          loading: vm.load.running,
          error: switch (vm.load.result) {
            Error(:final error) => error,
            _ => null,
          },
          onRetry: vm.load.execute,
          onRefresh: vm.load.execute,
          date: vm.date,
          onDateChanged: vm.selectDate,
          events: vm.events,
          nameOf: nameOf,
          onPrint: () async {
            final result = await guard(
              () => Printing.layoutPdf(
                name:
                    '${vm.group?.displayName ?? ''} ${vm.date.toIso8601String().substring(0, 10)}',
                onLayout: (_) => kitchenSheet(
                  l10n: l10n,
                  locale: Localizations.localeOf(context).toString(),
                  groupName: vm.group?.displayName ?? '',
                  date: vm.date,
                  events: vm.events,
                  nameOf: nameOf,
                ),
              ),
            );
            if (context.mounted) showFailure(context, result);
          },
        );
      },
    ),
  );
}
