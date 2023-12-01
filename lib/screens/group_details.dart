import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';

class GroupDetailsScreen extends StatelessWidget {
  final bool loading;
  final Group? group;

  const GroupDetailsScreen({
    super.key,
    required this.loading,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(group?.displayName ?? l10n.loading),
        actions: [
          IconButton(
            onPressed: () =>
                GroupManageRoute(groupId: group!.id.toString()).go(context),
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(group?.description ?? l10n.loading),
          ],
        ),
      ),
    );
  }
}
