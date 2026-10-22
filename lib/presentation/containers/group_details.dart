import 'package:material_ui/material_ui.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class GroupDetailsContainer extends StatelessWidget {
  final String groupId;

  const GroupDetailsContainer({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupDetailsViewModel(
      groupId: groupId,
      groups: context.read(),
      schedules: context.read(),
    ),
    child: Consumer<GroupDetailsViewModel>(
      builder: (context, vm, _) => GroupDetailsScreen(
        groupId: groupId,
        group: vm.group,
        isAdmin: vm.isAdmin,
        loading: vm.load.running,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        date: vm.date,
        onDateChanged: vm.selectDate,
        instances: vm.instances,
        onReplyChanged: (instance, reply) async {
          final result = await vm.reply(instance, reply);
          if (context.mounted) showFailure(context, result);
        },
      ),
    ),
  );
}
