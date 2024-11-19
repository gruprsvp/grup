import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

// The target member ID is the ID of the member that the user is replying for,
// which is not necessarily the user's own ID in the details screen.
typedef OnDetailsReplyChangedCallback = void Function(
    ScheduleEventDetails, int, ReplyOptions?);

class GroupScheduleDetailsScreen extends StatelessWidget {
  final datetimeFormat = DateFormat.yMMMd()..add_jm();

  final bool loading;
  final Group? group;
  final ScheduleEventDetails? schedule;
  final OnDetailsReplyChangedCallback? onReplyChanged;

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
              onReplyChanged: (reply) => onReplyChanged?.call(
                  schedule!, schedule!.targetMemberId!, reply),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: schedule?.memberReplies.length ?? 0,
              itemBuilder: (context, index) {
                final reply = schedule?.memberReplies.elementAt(index);
                return ListTile(
                  title: Text(reply?.$1.displayNameOverride ?? l10n.loading),
                  trailing: ReplyButton(
                    myReply: reply?.$2,
                    onReplyChanged: (r) =>
                        onReplyChanged?.call(schedule!, reply!.$1.id, r),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
