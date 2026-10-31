import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

/// The group's day. On a wide window, the open event ([selected], or else
/// the day's first) is shown next to it.
class GroupDetailsContainer extends StatelessWidget {
  final String groupId;

  /// The event the address opened, if any. Wide windows only: on narrow ones
  /// the event is a page of its own.
  final ScheduleInstanceKey? selected;

  const GroupDetailsContainer({
    super.key,
    required this.groupId,
    this.selected,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => GroupDetailsViewModel(
      groupId: groupId,
      groups: context.read(),
      schedules: context.read(),
      billing: context.read(),
      // Occurrences carry the wall-clock time in UTC fields.
      date: switch (selected?.at) {
        final at? => DateTime(at.year, at.month, at.day),
        null => null,
      },
    ),
    child: Consumer<GroupDetailsViewModel>(
      builder: (context, vm, _) {
        if (!TwoPane.isWide(context)) {
          return ReadableWidth(child: _screen(context, vm, null));
        }
        final first = vm.instances.firstOrNull;
        final open =
            selected ??
            (first == null
                ? null
                : (scheduleId: first.scheduleId, at: first.instanceDate));
        return TwoPane(
          list: _screen(context, vm, open),
          detail: open == null
              ? null
              : GroupScheduleDetailsContainer(
                  // A new event gets its own view model.
                  key: ValueKey(open),
                  groupId: groupId,
                  scheduleId: open.scheduleId,
                  instanceDate: open.at,
                  automaticallyImplyLeading: false,
                ),
        );
      },
    ),
  );

  GroupDetailsScreen _screen(
    BuildContext context,
    GroupDetailsViewModel vm,
    ScheduleInstanceKey? open,
  ) => GroupDetailsScreen(
    selected: open,
    // Under an open event's address, back leaves the group: popping
    // would only close the event, which looks like nothing happened.
    onBack: selected == null ? null : () => const HomeScreenRoute().go(context),
    groupId: groupId,
    group: vm.group,
    isAdmin: vm.isAdmin,
    loading: vm.load.running || vm.createSchedule.running,
    error: switch (vm.load.result) {
      Error(:final error) => error,
      _ => null,
    },
    onRetry: vm.load.execute,
    onRefresh: vm.load.execute,
    hasSchedules: vm.hasSchedules,
    hasOtherMembers: vm.hasOtherMembers,
    onCreateSchedule: (schedule) async {
      await vm.createSchedule.execute(schedule);
      if (context.mounted) showFailure(context, vm.createSchedule.result);
    },
    nextAfter: vm.nextAfter,
    date: vm.date,
    onDateChanged: vm.selectDate,
    instancesOn: vm.instancesOn,
    onReplyChanged: (instance, reply) async {
      final result = await vm.reply(instance, reply);
      if (context.mounted) showFailure(context, result);
    },
    closedAt: vm.closedAt,
  );
}
