import 'package:flutter/material.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';

/// A widget to display a list of groups and route to their details.
class GroupsList extends StatelessWidget {
  final Iterable<Group>? groups;

  const GroupsList({super.key, this.groups});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final group = groups!.elementAt(index);
        final picture = group.picture;
        final displayName = group.displayName;
        final description = group.description;

        return ListTile(
          leading: Hero(
            tag: picture ?? group.hashCode,
            child: CircleAvatar(
              radius: 32,
              foregroundImage: picture != null ? NetworkImage(picture) : null,
              child: Icon(
                Icons.group,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
          title: Hero(
              tag: group,
              child: Text(displayName, style: theme.textTheme.headlineMedium)),
          subtitle: description != null
              ? Text(description,
                  overflow: TextOverflow.fade, softWrap: false, maxLines: 1)
              : null,
          onTap: () =>
              GroupDetailsRoute(groupId: group.id.toString()).push(context),
        );
      },
      itemCount: groups?.length ?? 0,
    );
  }
}
