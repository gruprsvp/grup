import 'package:collection/collection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// Answers for [memberId]: the user, or (for admins) anyone in the group.
/// [previous] is what it replaces, and [name] is set when it's someone else.
typedef OnDetailsReplyChangedCallback = void Function({
  required String memberId,
  required ReplyOptions? reply,
  required ReplyOptions? previous,
  String? name,
});

/// Sets [memberId]'s usual answer for the occurrences [rule] matches.
/// [previous] is the rule it replaces, and [name] is set when it's someone
/// else.
typedef OnDetailsDefaultRuleChangedCallback = void Function({
  required String memberId,
  required RecurrenceRule? rule,
  required ReplyOptions? reply,
  required DefaultRule? previous,
  String? name,
});

/// The answer groups, in the order the organiser needs them: who's coming,
/// who to chase, who's out.
const _answerOrder = [ReplyOptions.yes, null, ReplyOptions.no];

class GroupScheduleDetailsScreen extends StatelessWidget {
  final bool loading;
  final Group? group;

  /// `null` until loaded, or when the event doesn't happen on this day.
  final ScheduleInstanceDetails? scheduleInstance;

  /// How the event recurs; usual answers need it.
  final RecurrenceRule? scheduleRule;
  final Exception? error;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final OnDetailsReplyChangedCallback? onReplyChanged;
  final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged;

  const GroupScheduleDetailsScreen({
    super.key,
    required this.loading,
    this.group,
    this.scheduleInstance,
    this.scheduleRule,
    this.error,
    this.onRetry,
    this.onRefresh,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  /// Lets [memberId]'s answers be changed, if there is one. [name] is `null`
  /// for the user's own row.
  ScheduleMemberTile _memberTile({
    required String eventName,
    required String displayName,
    required String? name,
    required String? memberId,
    ReplyOptions? reply,
    ReplyOptions? defaultReply,
    DefaultRule? defaultRule,
  }) {
    final rule = scheduleRule;
    return ScheduleMemberTile(
      name: displayName,
      isYou: name == null,
      eventName: eventName,
      // A one-off event has nothing to answer "usually".
      scheduleRule: rule == null || rule == CommonRecurrenceRules.once
          ? null
          : rule,
      reply: reply,
      defaultReply: defaultReply,
      defaultRule: defaultRule,
      onReplyChanged: memberId == null || onReplyChanged == null
          ? null
          : (answer) => onReplyChanged!(
              memberId: memberId,
              reply: answer,
              // Undo puts back the explicit answer, not a usual one.
              previous: reply,
              name: name,
            ),
      onDefaultRuleChanged: memberId == null || onDefaultRuleChanged == null
          ? null
          : (rule, answer) => onDefaultRuleChanged!(
              memberId: memberId,
              rule: rule,
              reply: answer,
              previous: defaultRule,
              name: name,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final details = scheduleInstance;
    final error = this.error;
    final notFound = details == null && !loading && error == null;
    final eventName = details?.displayName ?? '';
    // Only admins may answer for others.
    final canEditOthers = details?.canEditOthers ?? false;

    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: onRefresh ?? () async {},
        child: CustomScrollView(
          // Pull to refresh works on a short roster too.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(pinned: true, title: Text(eventName)),
            if (loading)
              const SliverToBoxAdapter(child: LinearProgressIndicator()),
            if (error != null)
              SliverToBoxAdapter(
                child: ErrorNotice(error: error, onRetry: onRetry),
              ),
            if (notFound)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.eventNotFound,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            if (details != null) ...[
              SliverToBoxAdapter(
                child: _Headcount(
                  groupName: group?.displayName,
                  details: details,
                ),
              ),
              SliverToBoxAdapter(
                child: _memberTile(
                  eventName: eventName,
                  displayName: l10n.you,
                  name: null,
                  memberId: details.targetMemberId,
                  reply: details.myReply,
                  defaultReply: details.myDefaultReply,
                  defaultRule: details.myDefaultRule,
                ),
              ),
              for (final answer in _answerOrder)
                if (details.repliesGroups.firstWhereOrNull(
                      (g) => g.reply == answer,
                    )
                    case final replyGroup?) ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  // The header stays on top only while its members scroll by.
                  SliverMainAxisGroup(
                    slivers: [
                      PinnedHeaderSliver(
                        child: _AnswerHeader(
                          reply: answer,
                          count: replyGroup.count,
                        ),
                      ),
                      SliverList.builder(
                        itemCount: replyGroup.members.length,
                        itemBuilder: (context, index) {
                          final el = replyGroup.members[index];
                          final name =
                              el.member.displayNameOverride ??
                              el.profile?.displayName ??
                              l10n.unknown;
                          return _memberTile(
                            eventName: eventName,
                            displayName: name,
                            name: name,
                            memberId: canEditOthers ? el.member.id : null,
                            reply: el.reply,
                            defaultReply: el.defaultReply,
                            defaultRule: el.defaultRule,
                          );
                        },
                      ),
                    ],
                  ),
                ],
            ],
            // CustomScrollView slivers don't apply the bottom view inset
            // automatically (unlike ListView), so pad past the system nav bar.
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Where, when, and who's coming: the answer the screen exists for.
class _Headcount extends StatelessWidget {
  const _Headcount({required this.groupName, required this.details});

  final String? groupName;
  final ScheduleInstanceDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final muted = theme.colorScheme.onSurfaceVariant;
    final locale = Localizations.localeOf(context).toString();
    final date = details.instanceDate;
    final usual = details.usualYes;
    final groupName = this.groupName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              ?groupName,
              DateFormat.MMMEd(locale).format(date),
              DateFormat.jm(locale).format(date),
            ].join(' · '),
            style: textTheme.bodyMedium?.copyWith(color: muted),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: keepTogether(l10n.eventComing(details.confirmedYes)),
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (usual > 0)
                  TextSpan(
                    text: '  ${keepTogether(l10n.eventUsually(usual))}',
                    style: textTheme.titleMedium?.copyWith(color: muted),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            [
              keepTogether(l10n.eventNoReply(details.count(null))),
              keepTogether(l10n.eventOut(details.count(ReplyOptions.no))),
            ].join(' · '),
            style: textTheme.bodyLarge?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}

/// Names an answer group and how many are in it. Opaque, since it stays on
/// top of the members scrolling under it.
class _AnswerHeader extends StatelessWidget {
  const _AnswerHeader({required this.reply, required this.count});

  final ReplyOptions? reply;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, color, label) = switch (reply) {
      ReplyOptions.yes => (FontAwesomeIcons.solidThumbsUp, yesColor, l10n.yes),
      ReplyOptions.no => (
        FontAwesomeIcons.solidThumbsDown,
        colorScheme.error,
        l10n.no,
      ),
      null => (
        FontAwesomeIcons.hourglassHalf,
        colorScheme.onSurfaceVariant,
        l10n.noReplyYet,
      ),
    };

    return ColoredBox(
      color: colorScheme.surfaceContainer,
      child: MergeSemantics(
        child: ListTile(
          leading: FaIcon(icon, color: color, size: 18),
          title: Text(label),
          trailing: Text(
            '$count',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
