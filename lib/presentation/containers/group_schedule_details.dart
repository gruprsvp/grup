import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class GroupScheduleDetailsContainer extends StatelessWidget {
  final String groupId;
  final String scheduleId;
  final DateTime instanceDate;

  const GroupScheduleDetailsContainer({
    super.key,
    required this.groupId,
    required this.scheduleId,
    required this.instanceDate,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ScheduleDetailsViewModel(
      groupId: groupId,
      scheduleId: scheduleId,
      instanceDate: instanceDate,
      groups: context.read(),
      schedules: context.read(),
    ),
    child: Consumer<ScheduleDetailsViewModel>(
      builder: (context, vm, _) => GroupScheduleDetailsScreen(
        loading: vm.load.running,
        group: vm.group,
        scheduleInstance: vm.details,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onReplyChanged: ({required memberId, required reply}) async {
          final result = await vm.reply(memberId, reply);
          if (context.mounted) showFailure(context, result);
        },
        onDefaultRuleChanged:
            ({required memberId, required rule, required reply}) async {
              final result = await vm.setDefaultRule(memberId, rule, reply);
              if (context.mounted) showFailure(context, result);
            },
      ),
    ),
  );
}
