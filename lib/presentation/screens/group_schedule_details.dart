import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupScheduleDetailsScreen extends StatelessWidget {
  final bool loading;
  final ScheduleInstance? schedule;

  const GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(schedule?.displayName ?? l10n.loading),
        // actions: [
        //   IconButton(
        //     onPressed: () =>
        //         GroupManageRoute(groupId: group!.id.toString()).push(context),
        //     icon: const FaIcon(FontAwesomeIcons.penToSquare),
        //   )
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Text(schedule?.myReply?.name ?? l10n.loading),
          )
        ],
      ),
      floatingActionButton: const DateFabContainer(),
    );
  }
}
