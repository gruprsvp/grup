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

// ! This kind of function signature is super risky, as it's easy to mix up the
// ! order of the arguments. It's better to use a data class or a map instead.
//   TODO(giorgio): I actually just fixed a bug because of this!
//   I should refactor this to use either branded types or a map.
typedef OnDetailsDefaultReplyChangedCallback = void Function(
    RecurrenceRule?, int, int, ReplyOptions?);

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
    final members = scheduleInstance?.members ?? [];
    final replies = scheduleInstance?.memberReplies ?? {};
    final defaultReplyOptions =
        scheduleInstance?.memberDefaultReplyOptions ?? {};
    final defaultReplies = scheduleInstance?.memberDefaultReplies ?? {};

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
            reply: scheduleInstance?.myReply,
            defaultReplyOption: scheduleInstance?.myDefaultReplyOption,
            defaultReply: scheduleInstance?.myDefaultReply,
            onReplyChanged: (reply) => onReplyChanged?.call(
                scheduleInstance!, scheduleInstance!.targetMemberId!, reply),
            onDefaultReplyChanged: (recurrenceRule, reply) =>
                onDefaultReplyChanged?.call(
                    recurrenceRule,
                    scheduleInstance!.scheduleId,
                    scheduleInstance!.targetMemberId!,
                    reply),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length ?? 0,
              itemBuilder: (context, index) {
                final (member, memberProfile) = members.elementAt(index);
                final name = member.displayNameOverride ??
                    memberProfile?.displayName ??
                    l10n.unknown;
                final reply = replies[member.id];
                final defaultReplyOption = defaultReplyOptions[member.id];
                final defaultReply = defaultReplies[member.id];

                return ScheduleMemberTile(
                  name: name,
                  reply: reply,
                  defaultReplyOption: defaultReplyOption,
                  defaultReply: defaultReply,
                  onReplyChanged: (reply) =>
                      onReplyChanged?.call(scheduleInstance!, member.id, reply),
                  onDefaultReplyChanged: (recurrenceRule, reply) =>
                      onDefaultReplyChanged?.call(recurrenceRule,
                          scheduleInstance!.scheduleId, member.id, reply),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
