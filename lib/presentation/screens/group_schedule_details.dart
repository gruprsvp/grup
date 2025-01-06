import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';

// The target member ID is the ID of the member that the user is replying for,
// which is not necessarily the user's own ID in the details screen.
typedef OnDetailsReplyChangedCallback = void Function(Reply?, ReplyOptions?);

// ! This kind of function signature is super risky, as it's easy to mix up the
// ! order of the arguments. It's better to use a data class or a map instead.
//   TODO(giorgio): I actually just fixed a bug because of this!
//   I should refactor this to use either branded types or a map.
typedef OnDetailsDefaultRuleChangedCallback = void Function(
    DefaultRule?, RecurrenceRule?, ReplyOptions?);

class GroupScheduleDetailsScreen extends StatelessWidget {
  final datetimeFormat = DateFormat.yMMMd()..add_jm();

  final bool loading;
  final Group? group;
  final ScheduleInstanceDetails? scheduleInstance;
  final OnDetailsReplyChangedCallback? onReplyChanged;
  final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged;

  GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.scheduleInstance,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final membersList = scheduleInstance?.membersList ?? [];

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
            reply: scheduleInstance?.myReply?.selectedOption,
            defaultReply: scheduleInstance?.myDefaultReply?.selectedOption,
            defaultRule: scheduleInstance?.myDefaultRule?.recurrenceRule,
            onReplyChanged: (replyOptions) =>
                onReplyChanged?.call(scheduleInstance?.myReply, replyOptions),
            onDefaultRuleChanged: (recurrenceRule, replyOptions) =>
                onDefaultRuleChanged?.call(scheduleInstance?.myDefaultRule,
                    recurrenceRule, replyOptions),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: membersList.length,
              itemBuilder: (context, index) {
                final el = membersList.elementAt(index);
                if (el is ScheduleInstanceMemberSeparator) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      el.reply == null
                          ? l10n.unknown
                          : el.reply == ReplyOptions.yes
                              ? l10n.yes
                              : l10n.no,
                    ),
                    trailing: Text('${el.count}'),
                    subtitle: Divider(),
                  );
                } else if (el is ScheduleInstanceMemberReply) {
                  final member = el.member;
                  final profile = el.profile;
                  final reply = el.reply;
                  final defaultReply = el.defaultReply;
                  final defaultRule = el.defaultRule;

                  final name = member.displayNameOverride ??
                      profile?.displayName ??
                      l10n.unknown;

                  return ScheduleMemberTile(
                    name: name,
                    reply: reply?.selectedOption,
                    defaultReply: defaultReply?.selectedOption,
                    defaultRule: defaultRule?.recurrenceRule,
                    onReplyChanged: (replyOptions) =>
                        onReplyChanged?.call(reply, replyOptions),
                    onDefaultRuleChanged: (recurrenceRule, replyOptions) =>
                        onDefaultRuleChanged?.call(
                            defaultRule, recurrenceRule, replyOptions),
                  );
                }
                throw Exception('Unknown member type: $el');
              },
            ),
          ),
        ],
      ),
    );
  }
}
