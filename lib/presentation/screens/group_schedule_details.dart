import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupScheduleDetailsScreen extends StatelessWidget {
  final datetimeFormat = DateFormat.yMMMd()..add_jm();

  final bool loading;
  final Group? group;
  final ScheduleSummary? schedule;
  final OnReplyChangedCallback? onReplyChanged;

  GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.schedule,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(group?.displayName ?? l10n.loading),
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
          ListTile(
            title: Text(schedule?.displayName ?? l10n.loading),
            subtitle: schedule?.eventDate != null
                ? Text(datetimeFormat.format(schedule!.eventDate))
                : Text(l10n.loading),
          ),
          ListTile(
            title: Text(l10n.you),
            trailing: ReplyButton(
              myReply: schedule?.myReply,
              onReplyChanged: (reply) => onReplyChanged?.call(schedule!, reply),
            ),
          ),
        ],
      ),
      floatingActionButton: const DateFabContainer(),
    );
  }
}
