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
    final groupName = group?.displayName ?? groupIdStr ?? '';
    final groupDescription = group?.description;

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: groupImage != null ? 256 : 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: groupImage != null
                          ? Hero(
                              tag: groupImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(24)),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(groupImage,
                                          fit: BoxFit.cover),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              colorScheme.surface
                                                  .withValues(alpha: 0.1),
                                              colorScheme.secondaryContainer
                                                  .withValues(alpha: 0.8),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : null,
                      collapseMode: CollapseMode.pin,
                      title: group != null
                          ? Hero(
                              tag: group!,
                              child: Text(groupName,
                                  style: textTheme.headlineMedium))
                          : null,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (groupDescription != null)
                          Padding(
                            padding:
                                EdgeInsets.only(top: 32, left: 16, right: 16),
                            child: Text(groupDescription),
                          ),
                        const DateDropdownContainer(),
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
