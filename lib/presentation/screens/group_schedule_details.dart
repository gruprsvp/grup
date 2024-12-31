import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';

// The target member ID is the ID of the member that the user is replying for,
// which is not necessarily the user's own ID in the details screen.
typedef OnDetailsReplyChangedCallback = void Function(
    ScheduleInstanceDetails, String, ReplyOptions?);

// ! This kind of function signature is super risky, as it's easy to mix up the
// ! order of the arguments. It's better to use a data class or a map instead.
//   TODO(giorgio): I actually just fixed a bug because of this!
//   I should refactor this to use either branded types or a map.
typedef OnDetailsDefaultRuleChangedCallback = void Function(
    RecurrenceRule?, String, String, ReplyOptions?);

class GroupScheduleDetailsScreen extends StatelessWidget {
  final dateFormat = DateFormat.yMMMd();
  final timeFormat = DateFormat.jm();

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
    final groupName = group?.displayName ?? l10n.loading;
    final scheduleName = scheduleInstance?.displayName ?? l10n.loading;
    final instanceDate = scheduleInstance?.instanceDate;
    final repliesGroups = scheduleInstance?.repliesGroups ?? [];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(groupName),
            floating: true,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        scheduleName,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    if (instanceDate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(dateFormat.format(instanceDate)),
                          Text(timeFormat.format(instanceDate)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ScheduleMemberTile(
              name: l10n.you,
              reply: scheduleInstance?.myReply,
              defaultReply: scheduleInstance?.myDefaultReply,
              defaultRule: scheduleInstance?.myDefaultRule,
              onReplyChanged: (reply) => onReplyChanged?.call(
                  scheduleInstance!, scheduleInstance!.targetMemberId!, reply),
              onDefaultRuleChanged: (recurrenceRule, reply) =>
                  onDefaultRuleChanged?.call(
                      recurrenceRule,
                      scheduleInstance!.scheduleId,
                      scheduleInstance!.targetMemberId!,
                      reply),
            ),
          ),
          for (final replyGroup in repliesGroups) ...[
            SliverPadding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: _SliverPersistentHeaderDelegate(
                  maxHeight: kToolbarHeight,
                  replyGroup: replyGroup,
                ),
              ),
            ),
            SliverList.builder(
              itemCount: replyGroup.members.length,
              itemBuilder: (context, index) {
                final el = replyGroup.members.elementAt(index);
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
                  reply: reply,
                  defaultReply: defaultReply,
                  defaultRule: defaultRule,
                  onReplyChanged: (reply) =>
                      onReplyChanged?.call(scheduleInstance!, member.id, reply),
                  onDefaultRuleChanged: (recurrenceRule, reply) =>
                      onDefaultRuleChanged?.call(recurrenceRule,
                          scheduleInstance!.scheduleId, member.id, reply),
                );
              },
            )
          ],
        ],
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.replyGroup,
    required this.maxHeight,
    this.minHeight = kToolbarHeight,
  });

  final double minHeight;
  final double maxHeight;
  final ScheduleInstanceRepliesGroup replyGroup;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    surfaceColorByReply(ReplyOptions? reply) {
      switch (reply) {
        case ReplyOptions.yes:
          return colorScheme.surfaceContainerHighest;
        case ReplyOptions.no:
          return colorScheme.surfaceContainerHigh;
        default:
          return colorScheme.surfaceContainer;
      }
    }

    return SizedBox.expand(
      child: Container(
        color: surfaceColorByReply(replyGroup.reply),
        child: ListTile(
          dense: overlapsContent,
          title: Text(
            replyGroup.reply == null
                ? l10n.unknown
                : replyGroup.reply == ReplyOptions.yes
                    ? l10n.yes
                    : l10n.no,
          ),
          trailing: Text('${replyGroup.count}'),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        replyGroup != oldDelegate.replyGroup;
  }
}
