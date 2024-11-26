import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupManageScreen extends StatelessWidget {
  final Group? group;
  final bool loading;
  final ValueSetter<int>? onDelete;

  const GroupManageScreen({
    super.key,
    required this.loading,
    this.group,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(l10n.delete),
                      iconColor: Theme.of(context).colorScheme.error),
                ),
              ],
              onSelected: (value) async {
                if (value == 'delete') {
                  await _confirmDelete(context, group!.id);
                }
              },
            )
          ],
          bottom: TabBar(tabs: [
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
          ]),
        ),
        body: TabBarView(
          children: [
            group != null
                ? GroupMembersContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
            group != null
                ? GroupEventsContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
            group != null
                ? GroupFormContainer(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
          ],
        ),
      ),
    );
  }

  /// Shows a confirmation dialog and deletes the group if confirmed.
  _confirmDelete(BuildContext context, int groupId) async {
    final doDelete = await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          final theme = Theme.of(context);
          final nav = Navigator.of(context);

          return AlertDialog.adaptive(
            icon: const Icon(Icons.logout),
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
        });

    if (doDelete == null || !doDelete) return;
    onDelete?.call(groupId);
  }
}
