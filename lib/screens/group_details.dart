import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(group?.displayName ?? 'Loading...'),
        actions: [
          IconButton(
            onPressed: () =>
                GroupEditRoute(groupId: group!.id.toString()).go(context),
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(group?.description ?? 'Loading...'),
          ],
        ),
      ),
    );
  }
}
