import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/containers/containers.dart';
import 'package:parousia/models/models.dart';

class GroupManageScreen extends StatelessWidget {
  final Group? group;
  final bool loading;

  const GroupManageScreen({
    super.key,
    required this.loading,
    this.group,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(group?.displayName ?? l10n.loading),
          bottom: TabBar(tabs: [
            Tab(
              text: l10n.members,
              icon: const Icon(Icons.people),
            ),
            Tab(
              text: l10n.events,
              icon: const Icon(Icons.event),
            ),
            Tab(
              text: l10n.details,
              icon: const Icon(Icons.badge_outlined),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Members')),
            Center(child: Text('Events')),
            group != null
                ? EditGroup(groupId: group!.id.toString())
                : Center(child: Text(l10n.loading)),
          ],
        ),
      ),
    );
  }
}
