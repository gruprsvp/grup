import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/result.dart';
import 'package:provider/provider.dart';

class GroupScheduleDetailsContainer extends StatelessWidget {
  final String groupId;
  final String scheduleId;
  final DateTime instanceDate;

  /// Whether to show a back button: not when open next to the group's list.
  final bool automaticallyImplyLeading;

  const GroupScheduleDetailsContainer({
    super.key,
    required this.groupId,
    required this.scheduleId,
    required this.instanceDate,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ScheduleDetailsViewModel(
      groupId: groupId,
      scheduleId: scheduleId,
      instanceDate: instanceDate,
      groups: context.read(),
      schedules: context.read(),
      billing: context.read(),
    ),
    child: Consumer<ScheduleDetailsViewModel>(
      builder: (context, vm, _) => GroupScheduleDetailsScreen(
        automaticallyImplyLeading: automaticallyImplyLeading,
        loading: vm.load.running,
        closedAt: vm.closedAt,
        lateMembers: vm.lateMembers,
        group: vm.group,
        scheduleInstance: vm.details,
        scheduleRule: vm.scheduleRule,
        error: switch (vm.load.result) {
          Error(:final error) => error,
          _ => null,
        },
        onRetry: vm.load.execute,
        onRefresh: vm.load.execute,
        onReplyChanged:
            ({
              required memberId,
              required reply,
              required previous,
              name,
            }) async {
              final result = await vm.reply(memberId, reply);
              if (!context.mounted) return;
              showFailure(context, result);
              // Answering for someone else is easy to do by mistake while
              // scrolling the roster: say what changed, and offer a way back.
              if (result is Ok && name != null) {
                final l10n = AppLocalizations.of(context)!;
                showUndo(context, switch (reply) {
                  ReplyOptions.yes => l10n.markedComing(name),
                  ReplyOptions.no => l10n.markedNotComing(name),
                  null => l10n.answerCleared(name),
                }, () => vm.reply(memberId, previous));
              }
            },
        onDefaultRuleChanged:
            ({
              required memberId,
              required rule,
              required reply,
              required previous,
              name,
            }) async {
              final result = await vm.setDefaultRule(memberId, rule, reply);
              if (!context.mounted) return;
              showFailure(context, result);
              if (result is Ok) {
                final l10n = AppLocalizations.of(context)!;
                showUndo(
                  context,
                  reply == null
                      ? l10n.usualAnswerRemoved
                      : l10n.usualAnswerSaved,
                  () => vm.setDefaultRule(
                    memberId,
                    previous?.recurrenceRule,
                    previous?.selectedOption,
                  ),
                );
              }
            },
      ),
    ),
  );
}
