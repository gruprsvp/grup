import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';

/// Answers for [memberId]: the user, or (for admins) anyone in the group.
typedef OnDetailsReplyChangedCallback = void Function({
  required String memberId,
  required ReplyOptions? reply,
});

/// Sets [memberId]'s default answer for the occurrences [rule] matches.
typedef OnDetailsDefaultRuleChangedCallback = void Function({
  required String memberId,
  required RecurrenceRule? rule,
  required ReplyOptions? reply,
});

class GroupScheduleDetailsScreen extends StatelessWidget {
  final dateFormat = DateFormat.yMMMd();
  final timeFormat = DateFormat.jm();

  final bool loading;
  final Group? group;

  /// `null` until loaded: the answer buttons stay disabled until then.
  final ScheduleInstanceDetails? scheduleInstance;
  final Exception? error;
  final VoidCallback? onRetry;
  final OnDetailsReplyChangedCallback? onReplyChanged;
  final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged;

  GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.scheduleInstance,
    this.error,
    this.onRetry,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  /// Lets [memberId]'s answers be changed, if there is one.
  ScheduleMemberTile _memberTile({
    required String name,
    required String? memberId,
    ReplyOptions? reply,
    ReplyOptions? defaultReply,
    DefaultRule? defaultRule,
  }) => ScheduleMemberTile(
    name: name,
    reply: reply,
    defaultReply: defaultReply,
    defaultRule: defaultRule,
    onReplyChanged: memberId == null || onReplyChanged == null
        ? null
        : (reply) => onReplyChanged!(memberId: memberId, reply: reply),
    onDefaultRuleChanged: memberId == null || onDefaultRuleChanged == null
        ? null
        : (rule, reply) => onDefaultRuleChanged!(
            memberId: memberId,
            rule: rule,
            reply: reply,
          ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupName = group?.displayName ?? l10n.loading;
    final scheduleName = scheduleInstance?.displayName ?? l10n.loading;
    final instanceDate = scheduleInstance?.instanceDate;
    final repliesGroups = scheduleInstance?.repliesGroups ?? [];
    // Only admins may answer for others.
    final canEditOthers = scheduleInstance?.canEditOthers ?? false;
    final error = this.error;

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
          if (loading)
            const SliverToBoxAdapter(child: LinearProgressIndicator()),
          if (error != null)
            SliverToBoxAdapter(
              child: ErrorNotice(error: error, onRetry: onRetry),
            ),
          SliverToBoxAdapter(
            child: _memberTile(
              name: l10n.you,
              memberId: scheduleInstance?.targetMemberId,
              reply: scheduleInstance?.myReply,
              defaultReply: scheduleInstance?.myDefaultReply,
              defaultRule: scheduleInstance?.myDefaultRule,
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

                final name =
                    member.displayNameOverride ??
                    profile?.displayName ??
                    l10n.unknown;

                return _memberTile(
                  name: name,
                  memberId: canEditOthers ? member.id : null,
                  reply: reply,
                  defaultReply: defaultReply,
                  defaultRule: defaultRule,
                );
              },
            ),
          ],
          // CustomScrollView slivers don't apply the bottom view inset
          // automatically (unlike ListView), so pad past the system nav bar.
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({
    required this.replyGroup,
    required this.maxHeight,
  });

  final double minHeight = kToolbarHeight;
  final double maxHeight;
  final ScheduleInstanceRepliesGroup replyGroup;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
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
