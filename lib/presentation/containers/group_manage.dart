import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class GroupManageContainer extends StatelessWidget {
  final String groupId;

  const GroupManageContainer({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupManageViewModel(
      groupId: groupId,
      groups: context.read(),
      schedules: context.read(),
    ),
    child: Consumer<GroupManageViewModel>(
      builder: (context, vm, _) => GroupManageScreen(
        groupId: groupId,
        group: vm.group,
        loading:
            vm.load.running ||
            vm.update.running ||
            vm.invite.running ||
            vm.createSchedule.running ||
            vm.deleteSchedule.running,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onDelete: vm.delete.running
            ? null
            : () async {
                await vm.delete.execute();
                if (!context.mounted) return;
                showFailure(context, vm.delete.result);
                if (vm.delete.completed) const HomeScreenRoute().go(context);
              },
        members: vm.members,
        onInvite: (contacts) async {
          await vm.invite.execute(contacts);
          if (context.mounted) showFailure(context, vm.invite.result);
        },
        schedules: vm.schedules,
        onCreateSchedule: (schedule) async {
          await vm.createSchedule.execute(schedule);
          if (context.mounted) showFailure(context, vm.createSchedule.result);
        },
        onDeleteSchedule: (schedule) async {
          await vm.deleteSchedule.execute(schedule);
          if (context.mounted) showFailure(context, vm.deleteSchedule.result);
        },
        onSave: (args) async {
          await vm.update.execute((group: args.$1, image: args.$2));
          if (context.mounted) showFailure(context, vm.update.result);
        },
      ),
    ),
  );
}
