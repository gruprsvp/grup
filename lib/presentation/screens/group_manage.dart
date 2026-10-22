import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';

/// Where an admin manages a group's members, events and details.
class GroupManageScreen extends StatelessWidget {
  final String groupId;
  final Group? group;
  final bool loading;
  final Exception? error;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  final List<(Member, Profile?)> members;
  final OnInviteCallback? onInvite;

  final List<Schedule> schedules;
  final Future<RruleL10n>? rruleL10n;
  final ValueSetter<Schedule>? onCreateSchedule;
  final ValueSetter<Schedule>? onDeleteSchedule;

  final OnGroupSaveCallback? onSave;

  const GroupManageScreen({
    super.key,
    required this.groupId,
    required this.loading,
    this.group,
    this.error,
    this.onRetry,
    this.onDelete,
    this.members = const [],
    this.onInvite,
    this.schedules = const [],
    this.rruleL10n,
    this.onCreateSchedule,
    this.onDeleteSchedule,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final group = this.group;
    final error = this.error;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          actions: [
            PopupMenuButton(
              enabled: onDelete != null,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(l10n.delete),
                    iconColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              onSelected: (value) async {
                if (value == 'delete') await _confirmDelete(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: l10n.members,
                icon: const FaIcon(FontAwesomeIcons.peopleGroup),
              ),
              Tab(
                text: l10n.events,
                icon: const FaIcon(FontAwesomeIcons.calendarDay),
              ),
              Tab(
                text: l10n.details,
                icon: const FaIcon(FontAwesomeIcons.quoteRight),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            if (loading) const LinearProgressIndicator(),
            if (error != null) ErrorNotice(error: error, onRetry: onRetry),
            Expanded(
              child: TabBarView(
                children: [
                  GroupMembers(members: members, onInvite: onInvite),
                  GroupEvents(
                    groupId: groupId,
                    schedules: schedules,
                    onCreate: onCreateSchedule,
                    onDelete: onDeleteSchedule,
                    rrulel10n: rruleL10n,
                  ),
                  group != null
                      // Keyed by the group, so the form shows it once loaded.
                      ? GroupForm(
                          key: ValueKey(group.id),
                          group: group,
                          onSave: onSave ?? (_) {},
                        )
                      : Center(child: Text(l10n.loading)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a confirmation dialog and deletes the group if confirmed.
  Future<void> _confirmDelete(BuildContext context) async {
    final doDelete = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        final nav = Navigator.of(context);

        return AlertDialog.adaptive(
          icon: const Icon(Icons.delete),
          title: Text(l10n.deleteGroup),
          content: Text(l10n.deleteGroupConfirmation),
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

    if (doDelete == true) onDelete?.call();
  }
}
