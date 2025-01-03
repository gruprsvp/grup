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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final groupId = group?.id;
    final groupIdStr = groupId?.toString();
    final groupImage = group?.picture;
    final groupName = group?.displayName ?? l10n.loading;
    final groupDescription = group?.description;

    final imageOrDescriptionToShow =
        groupImage != null || groupDescription != null;

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    title: Text(groupName),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: const DateDropdownContainer(),
                    ),
                  ),
                  if (imageOrDescriptionToShow)
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          if (groupImage != null)
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Hero(
                                tag: groupImage,
                                child: ProfilePicture(
                                  image: NetworkImage(groupImage),
                                  icon: Icons.group,
                                  radius: 128,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          if (groupDescription != null)
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(groupDescription),
                            )
                        ],
                      ),
                    ),
                ],
            body: SchedulesListContainer(groupId: groupIdStr)),
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
