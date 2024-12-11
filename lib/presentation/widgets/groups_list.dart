import 'package:flutter/material.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';

/// A widget to display a list of groups and route to their details.
class GroupsList extends StatelessWidget {
  final Iterable<Group>? groups;

  const GroupsList({super.key, this.groups});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final group = groups!.elementAt(index);
        return ListTile(
          // TODO avatar and description
          title: Text(group.displayName),
          subtitle: group.description != null
              ? Text(group.description!.split('\n').first)
              : null,
          onTap: () =>
              GroupDetailsRoute(groupId: group.id.toString()).push(context),
        );
      },
      itemCount: groups?.length ?? 0,
    );
  }
}
