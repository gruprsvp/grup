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
                                    child: Image.network(groupImage,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )
                            : null,
                        collapseMode: CollapseMode.pin,
                        title: Hero(
                          tag: groupName,
                          child:
                              Text(groupName, style: textTheme.headlineMedium),
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (groupDescription != null) Text(groupDescription),
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
