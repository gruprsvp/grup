import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';

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
          onTap: () => print('TODO: open group ${group.id}'),
        );
      },
      itemCount: groups?.length ?? 0,
    );
  }
}
