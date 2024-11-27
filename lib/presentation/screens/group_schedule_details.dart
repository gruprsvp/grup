import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';

// The target member ID is the ID of the member that the user is replying for,
// which is not necessarily the user's own ID in the details screen.
typedef OnDetailsReplyChangedCallback = void Function(
    ScheduleInstanceDetails, int, ReplyOptions?);

typedef OnDetailsDefaultReplyChangedCallback = void Function(
    RecurrenceRule?, int, int, ReplyOptions);

class GroupScheduleDetailsScreen extends StatelessWidget {
  final datetimeFormat = DateFormat.yMMMd()..add_jm();

  final bool loading;
  final Group? group;
  final ScheduleInstanceDetails? scheduleInstance;
  final OnDetailsReplyChangedCallback? onReplyChanged;
  final OnDetailsDefaultReplyChangedCallback? onDefaultReplyChanged;

  GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.scheduleInstance,
    this.onReplyChanged,
    this.onDefaultReplyChanged,
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
            title: Text(scheduleInstance?.displayName ?? l10n.loading),
            subtitle: scheduleInstance?.instanceDate != null
                ? Text(datetimeFormat.format(scheduleInstance!.instanceDate))
                : Text(l10n.loading),
          ),
          ScheduleMemberTile(
            name: l10n.you,
            myReply: scheduleInstance?.myReply,
            myDefaultOption: scheduleInstance?.myDefaultOption,
            onReplyChanged: (reply) => onReplyChanged?.call(
                scheduleInstance!, scheduleInstance!.targetMemberId!, reply),
            onDefaultReplyChanged: (defaultOption, reply) =>
                onDefaultReplyChanged?.call(
                    defaultOption,
                    scheduleInstance!.scheduleId,
                    scheduleInstance!.targetMemberId!,
                    reply),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scheduleInstance?.memberReplies.length ?? 0,
              itemBuilder: (context, index) {
                final reply = scheduleInstance?.memberReplies.elementAt(index);
                final defaultOption =
                    scheduleInstance?.memberDefaultOptions.elementAt(index);

                return ScheduleMemberTile(
                  name: reply?.$1.displayNameOverride ?? l10n.loading,
                  myReply: reply?.$2,
                  myDefaultOption: defaultOption,
                  onReplyChanged: (r) =>
                      onReplyChanged?.call(scheduleInstance!, reply!.$1.id, r),
                  onDefaultReplyChanged: (defaultOption, r) =>
                      onDefaultReplyChanged?.call(defaultOption,
                          scheduleInstance!.scheduleId, reply!.$1.id, r),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
