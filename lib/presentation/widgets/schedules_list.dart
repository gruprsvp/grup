import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:styled_text/styled_text.dart';

typedef OnReplyChangedCallback = void Function(
  ScheduleInstanceSummary,
  ReplyOptions?,
);

class SchedulesList extends StatelessWidget {
  final List<ScheduleInstanceSummary>? schedules;
  final OnReplyChangedCallback? onReplyChanged;
  final String groupId;
  final bool isAdmin;

  const SchedulesList({
    super.key,
    this.schedules,
    this.onReplyChanged,
    required this.groupId,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final schedules = this.schedules;
    if (schedules == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return schedules.isNotEmpty
        ? ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) => ScheduleTile(
              schedule: schedules[index],
              onReplyChanged: onReplyChanged == null
                  ? null
                  : (reply) => onReplyChanged!(schedules[index], reply),
              onScheduleTapped: (schedule) => GroupScheduleDetailsRoute(
                groupId: schedule.groupId,
                scheduleId: schedule.scheduleId,
                at: schedule.instanceDate,
              ).go(context),
            ),
          )
        : EmptyState(
            image: 'add-events.webp',
            text: StyledText(
              text: isAdmin
                  ? l10n.groupEmptyEventsAdmin
                  : l10n.groupEmptyEventsUser,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
              tags: isAdmin
                  ? {
                      'manage': StyledTextWidgetTag(
                        TextButton.icon(
                          icon: const Icon(Icons.edit),
                          label: Text(l10n.groupManage),
                          onPressed: () =>
                              GroupManageRoute(groupId: groupId).go(context),
                        ),
                      ),
                    }
                  : null,
            ),
          );
  }
}
