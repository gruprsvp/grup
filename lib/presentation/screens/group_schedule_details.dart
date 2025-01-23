import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:rrule/rrule.dart';
import 'package:timezone/timezone.dart';

// The target member ID is the ID of the member that the user is replying for,
// which is not necessarily the user's own ID in the details screen.
typedef OnDetailsReplyChangedCallback = void Function(Reply, ReplyOptions?);

// ! This kind of function signature is super risky, as it's easy to mix up the
// ! order of the arguments. It's better to use a data class or a map instead.
//   TODO(giorgio): I actually just fixed a bug because of this!
//   I should refactor this to use either branded types or a map.
typedef OnDetailsDefaultRuleChangedCallback = void Function(
    DefaultRule, RecurrenceRule?, ReplyOptions?);

class GroupScheduleDetailsScreen extends StatelessWidget {
  final dateFormat = DateFormat.yMMMd();
  final timeFormat = DateFormat.jm();

  final bool loading;
  final Group group;
  final ScheduleInstanceDetails scheduleInstance;
  final OnDetailsReplyChangedCallback? onReplyChanged;
  final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged;

  GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    required this.scheduleInstance,
    required this.group,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  Future<List<String>> _getFormatedDateTime() async {
    final scheduleTimezone = scheduleInstance.schedule.timezone;
    final localTimeZone = await FlutterTimezone.getLocalTimezone();

    if (scheduleTimezone == localTimeZone) {
      return [
        dateFormat.format(scheduleInstance.instanceDate),
        timeFormat.format(scheduleInstance.instanceDate)
      ];
    }

    final date = scheduleInstance.instanceDate;
    final remoteLocation = getLocation(scheduleTimezone);
    final remoteTime = TZDateTime(remoteLocation, date.year, date.month,
        date.day, date.hour, date.minute);
    final localTime =
        TZDateTime.from(remoteTime.toUtc(), getLocation(localTimeZone));
    return [dateFormat.format(localTime), timeFormat.format(localTime)];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupName = group.displayName;
    final scheduleName = scheduleInstance.displayName;
    final repliesGroups = scheduleInstance.repliesGroups ?? [];

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FutureBuilder<List<String>>(
                            future: _getFormatedDateTime(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Text('No data');
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(snapshot.data![0]),
                                    Text(snapshot.data![1]),
                                  ],
                                );
                              }
                            })
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
              reply: scheduleInstance.myReply?.selectedOption,
              defaultReply: scheduleInstance.myDefaultReply?.selectedOption,
              defaultRule: scheduleInstance.myDefaultRule?.recurrenceRule,
              onReplyChanged: (replyOptions) {
                final reply = scheduleInstance.myReply ??
                    Reply(
                        member: scheduleInstance.targetMember!,
                        schedule: scheduleInstance.schedule,
                        instanceDate: scheduleInstance.instanceDate);

                onReplyChanged?.call(reply, replyOptions);
              },
              onDefaultRuleChanged: (recurrenceRule, replyOptions) {
                final defaultRule = scheduleInstance.myDefaultRule ??
                    DefaultRule(
                      member: scheduleInstance.targetMember!,
                      schedule: scheduleInstance.schedule,
                    );
                onDefaultRuleChanged?.call(
                    defaultRule, recurrenceRule, replyOptions);
              },
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
                final reply = el.reply ??
                    Reply(
                        member: member,
                        schedule: scheduleInstance.schedule,
                        instanceDate: scheduleInstance.instanceDate);
                final defaultReply = el.defaultReply;
                final defaultRule = el.defaultRule ??
                    DefaultRule(
                      member: member,
                      schedule: scheduleInstance.schedule,
                    );

                final name = member.displayNameOverride ??
                    profile?.displayName ??
                    l10n.unknown;

                return ScheduleMemberTile(
                  name: name,
                  reply: reply.selectedOption,
                  defaultReply: defaultReply?.selectedOption,
                  defaultRule: defaultRule.recurrenceRule,
                  onReplyChanged: (replyOptions) =>
                      onReplyChanged?.call(reply, replyOptions),
                  onDefaultRuleChanged: (recurrenceRule, replyOptions) =>
                      onDefaultRuleChanged?.call(
                          defaultRule, recurrenceRule, replyOptions),
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
