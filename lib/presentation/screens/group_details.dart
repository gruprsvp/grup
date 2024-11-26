import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupDetailsScreen extends StatelessWidget {
  final bool loading;
  final bool isAdmin;
  final Group? group;
  final Function(int) onDelete;

  const GroupDetailsScreen({
    super.key,
    required this.loading,
    required this.isAdmin,
    this.group,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupId = group?.id;
    final groupIdStr = groupId?.toString();
    final groupDescription = group?.description;

    return Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          actions: [
            if (isAdmin && groupId != null)
              IconButton(
                onPressed: () => _confirmDelete(context, groupId),
                icon: const Icon(Icons.delete),
              )
          ],
        ),
        body: Column(
          children: [
            const DateDropdownContainer(),
            if (groupDescription != null) Text(groupDescription),
            if (groupId != null)
              Expanded(child: SchedulesListContainer(groupId: groupId)),
          ],
        ),
        floatingActionButton: isAdmin && groupIdStr != null
            ? FloatingActionButton.extended(
                onPressed: () =>
                    GroupManageRoute(groupId: groupIdStr).push(context),
                label: Text(l10n.groupManage),
                icon: const Icon(Icons.edit),
              )
            : null);
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
    onDelete(groupId);
  }
}
