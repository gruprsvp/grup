import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(group?.displayName ?? l10n.loading),
        actions: [
          isAdmin
              ? IconButton(
                  onPressed: () =>
                      GroupManageRoute(groupId: group!.id.toString())
                          .push(context),
                  icon: const FaIcon(FontAwesomeIcons.penToSquare),
                )
              : Container()
        ],
      ),
      body: Column(
        children: [
          const DateDropdownContainer(),
          ...(group?.description != null ? [Text(group!.description!)] : []),
          Expanded(
            child: SchedulesListContainer(groupId: group!.id),
          )
        ],
      ),
    );
  }
}
