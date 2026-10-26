import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class GroupMemberDetailsContainer extends StatelessWidget {
  final String groupId;
  final String memberId;

  const GroupMemberDetailsContainer({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => MemberDetailsViewModel(
      groupId: groupId,
      memberId: memberId,
      groups: context.read(),
    ),
    child: Consumer<MemberDetailsViewModel>(
      builder: (context, vm, _) => GroupMemberDetailsScreen(
        loading:
            vm.load.running ||
            vm.setRole.running ||
            vm.remove.running ||
            vm.createInvite.running ||
            vm.cancelInvites.running,
        isCurrentUser: vm.isCurrentUser,
        isAdmin: vm.isAdmin,
        group: vm.group,
        member: vm.member,
        profile: vm.profile,
        invites: vm.invites,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onCreateInvite: () async {
          await vm.createInvite.execute();
          if (context.mounted) showFailure(context, vm.createInvite.result);
        },
        onCancelInvites: () async {
          await vm.cancelInvites.execute();
          if (context.mounted) showFailure(context, vm.cancelInvites.result);
        },
        onSetRole: (role) async {
          await vm.setRole.execute(role);
          if (context.mounted) showFailure(context, vm.setRole.result);
        },
        onRemove: () async {
          final leaving = vm.isCurrentUser;
          await vm.remove.execute();
          if (!context.mounted) return;
          showFailure(context, vm.remove.result);
          if (!vm.remove.completed) return;
          // Leaving the group: it's gone from the user's list.
          leaving ? const HomeScreenRoute().go(context) : context.pop();
        },
      ),
    ),
  );
}
