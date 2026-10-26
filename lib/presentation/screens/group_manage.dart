import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

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
  final ValueSetter<Schedule>? onCreateSchedule;
  final ValueSetter<Schedule>? onDeleteSchedule;

  final OnGroupSaveCallback? onSave;

  /// What the group's plan allows here.
  final GroupAccess? access;

  /// Exports everyone's answers over a range of days.
  final VoidCallback? onExport;

  /// Sets when changes to an event's answers close.
  final void Function(Schedule schedule, int? minutes)? onSetCutoff;

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
    this.onCreateSchedule,
    this.onDeleteSchedule,
    this.onSave,
    this.access,
    this.onExport,
    this.onSetCutoff,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final group = this.group;
    final error = this.error;
    final access = this.access;
    final canExport =
        onExport != null && (access?.show(FeatureKey.exportCsv) ?? false);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          actions: [
            PopupMenuButton(
              enabled: onDelete != null || canExport,
              itemBuilder: (context) => [
                if (canExport)
                  PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: const Icon(Icons.file_download_outlined),
                      title: Text(l10n.exportAnswers),
                    ),
                  ),
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
                if (value == 'export') onExport?.call();
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
                    onSetCutoff: access?.show(FeatureKey.replyCutoffs) ?? false
                        ? onSetCutoff
                        : null,
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
