import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';
import 'package:styled_text/styled_text.dart';

class GroupEvents extends StatelessWidget {
  final Group? group; // TODO is this needed?
  final Iterable<Schedule>? schedules;
  final ValueSetter<Schedule>? onCreate;
  final ValueSetter<Schedule>? onDelete;
  final Future<RruleL10n>? rrulel10n;

  const GroupEvents({
    super.key,
    this.group,
    this.schedules,
    this.onCreate,
    this.onDelete,
    this.rrulel10n,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final topWidget = schedules?.isNotEmpty ?? false
        ? ListView.builder(
            itemCount: schedules?.length,
            itemBuilder: (context, index) {
              final schedule = schedules!.elementAt(index);
              return ListTile(
                title: Text(schedule.displayName),
                subtitle: FutureBuilder(
                    future: rrulel10n,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final rrl10n = snapshot.data as RruleL10n;
                        return Text(
                            schedule.recurrenceRule.toText(l10n: rrl10n));
                      }
                      return Text(l10n.loading);
                    }),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
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
                'newevent': StyledTextWidgetTag(TextButton(
                  onPressed: () => _createNewEvent(context),
                  child: Text(l10n.createNewEvent),
                ))
              },
            ),
          );

    return Padding(
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
    );
  }

  _createNewEvent(BuildContext context) async {
    final result =
        await GroupScheduleCreateRoute(groupId: group!.id).push(context);

    if (result is! Schedule) {
      // TODO error handling
      return;
    }

    final newSchedule = result.copyWith(group: group);
    onCreate?.call(newSchedule);
  }

  _deleteEvent(BuildContext context, Schedule schedule) async {
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
        });

    if (doDelete == null || !doDelete) return;

    onDelete?.call(schedule);
  }
}
