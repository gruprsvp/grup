import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupDetailsScreen extends StatelessWidget {
  final bool loading;
  final bool isAdmin;
  final Group? group;

  const GroupDetailsScreen({
    super.key,
    required this.loading,
    required this.isAdmin,
    this.group,
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
}
