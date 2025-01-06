import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:styled_text/styled_text.dart';

typedef OnReplyChangedCallback = void Function(
    ScheduleInstanceSummary, Reply?, ReplyOptions?);

class SchedulesList extends StatelessWidget {
  final Iterable<ScheduleInstanceSummary>? scheduleInstances;
  final OnReplyChangedCallback? onReplyChanged;
  final String? groupId;
  final bool isAdmin;

  const SchedulesList({
    super.key,
    this.scheduleInstances,
    this.onReplyChanged,
    this.groupId,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (scheduleInstances == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    return scheduleInstances?.isNotEmpty ?? false
        ? ListView.builder(
            itemCount: scheduleInstances!.length,
            itemBuilder: (context, index) => ScheduleTile(
              scheduleInstance: scheduleInstances!.elementAt(index),
              onReplyChanged: (reply, replyOption) => onReplyChanged?.call(
                  scheduleInstances!.elementAt(index), reply, replyOption),
              onScheduleTapped: (schedule) => GroupScheduleDetailsRoute(
                      groupId: schedule.groupId,
                      scheduleId: schedule.schedule.id!)
                  .push(context),
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
                              GroupManageRoute(groupId: groupId!).push(context),
                        ),
                      )
                    }
                  : null,
            ),
          );
  }
}
