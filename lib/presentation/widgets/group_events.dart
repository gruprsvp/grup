import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:styled_text/styled_text.dart';

class GroupEvents extends StatelessWidget {
  final String groupId;
  final List<Schedule>? schedules;
  final ValueSetter<Schedule>? onCreate;
  final ValueSetter<Schedule>? onDelete;

  /// Sets when changes to an event's answers close; null where the group's
  /// plan doesn't include cutoffs.
  final void Function(Schedule schedule, int? minutes)? onSetCutoff;

  const GroupEvents({
    super.key,
    required this.groupId,
    this.schedules,
    this.onCreate,
    this.onDelete,
    this.onSetCutoff,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final topWidget = schedules?.isNotEmpty ?? false
        ? ListView.builder(
            itemCount: schedules!.length,
            itemBuilder: (context, index) {
              final schedule = schedules![index];
              final onSetCutoff = this.onSetCutoff;
              return ListTile(
                title: Text(schedule.displayName),
                subtitle: Text(
                  [
                    recurrenceLabel(l10n, schedule.recurrenceRule),
                    if (onSetCutoff != null)
                      '${l10n.cutoffLabel}: '
                          '${cutoffLabel(l10n, schedule.cutoffMinutesBefore)}',
                  ].join(' · '),
                ),
                onTap: onSetCutoff == null
                    ? null
                    : () async {
                        final picked = await pickCutoff(
                          context,
                          current: schedule.cutoffMinutesBefore,
                        );
                        if (picked != null) {
                          onSetCutoff(schedule, picked.minutes);
                        }
                      },
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: l10n.deleteSchedule,
                  onPressed: () => _deleteEvent(context, schedule),
                ),
              );
            },
          )
        : EmptyState(
            image: 'events.webp',
            text: StyledText(
              text: l10n.eventsEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
              tags: {
                'newevent': StyledTextWidgetTag(
                  TextButton(
                    onPressed: () => _createNewEvent(context),
                    child: Text(l10n.createNewEvent),
                  ),
                ),
              },
            ),
          );

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Expanded(child: topWidget),
            FilledButton(
              onPressed: () => _createNewEvent(context),
              child: Text(l10n.createNewEvent),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewEvent(BuildContext context) async {
    final result = await GroupScheduleCreateRoute(groupId: groupId)
        .push<Schedule>(context);
    // Null when the user backed out without saving.
    if (result != null) onCreate?.call(result.copyWith(groupId: groupId));
  }

  Future<void> _deleteEvent(BuildContext context, Schedule schedule) async {
    final doDelete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        final nav = Navigator.of(context);

        return AlertDialog.adaptive(
          icon: const Icon(Icons.logout),
          title: Text(l10n.deleteSchedule),
          content: Text(l10n.deleteScheduleConfirmation),
          actions: [
            TextButton(
              onPressed: () => nav.pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => nav.pop(true),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (doDelete == null || !doDelete) return;

    onDelete?.call(schedule);
  }
}
