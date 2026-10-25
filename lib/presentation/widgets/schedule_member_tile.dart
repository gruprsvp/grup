import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

class ScheduleMemberTile extends StatelessWidget {
  final String name;

  /// The member's picture, if they have one.
  final String? picture;

  /// The user's own row: it invites them to set a usual answer.
  final bool isYou;
  final String eventName;

  /// How the event recurs; `null` for a one-off, which has no usual answers.
  final RecurrenceRule? scheduleRule;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final DefaultRule? defaultRule;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final void Function(RecurrenceRule?, ReplyOptions?)? onDefaultRuleChanged;

  const ScheduleMemberTile({
    super.key,
    required this.name,
    this.picture,
    this.isYou = false,
    required this.eventName,
    this.scheduleRule,
    this.reply,
    this.defaultReply,
    this.defaultRule,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheduleRule = this.scheduleRule;
    final canSetUsual = scheduleRule != null && onDefaultRuleChanged != null;

    final status = switch ((reply, defaultReply)) {
      (ReplyOptions.yes, _) => l10n.answerComing,
      (ReplyOptions.no, _) => l10n.answerNotComing,
      (null, ReplyOptions.yes) => l10n.answerUsuallyComing,
      (null, ReplyOptions.no) => l10n.answerUsuallyNotComing,
      (null, null) => l10n.answerNoReply,
    };

    final defaultRule = this.defaultRule;
    final Widget? subtitle;
    if (defaultRule != null && scheduleRule != null) {
      final rule = defaultRule.recurrenceRule;
      final yes = defaultRule.selectedOption == ReplyOptions.yes;
      final when = recurrenceLabel(l10n, rule);
      subtitle = Text(
        rule == scheduleRule
            ? (yes ? l10n.usuallyIn : l10n.usuallyOut)
            : (yes ? l10n.usuallyInWhen(when) : l10n.usuallyOutWhen(when)),
      );
    } else if (isYou && canSetUsual) {
      subtitle = Text(
        l10n.setUsualAnswer,
        style: TextStyle(color: theme.colorScheme.primary),
      );
    } else {
      subtitle = null;
    }

    final picture = this.picture;
    final initials = getNameInitials(name) ?? '';
    return ListTile(
      // The name says who it is; the avatar is a face to find them by.
      leading: ExcludeSemantics(
        child: CircleAvatar(
          backgroundColor: isYou ? theme.colorScheme.primary : null,
          foregroundColor: isYou ? theme.colorScheme.onPrimary : null,
          foregroundImage: picture != null ? NetworkImage(picture) : null,
          child: isYou
              ? const Icon(Icons.person)
              : Text(initials, style: theme.textTheme.labelLarge),
        ),
      ),
      title: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        // The answer marks are visual; this says who answered what.
        semanticsLabel: '$name, $status',
      ),
      subtitle: subtitle,
      trailing: ReplyButtons(
        reply: reply,
        defaultReply: defaultReply,
        onReplyChanged: onReplyChanged,
      ),
      onTap: canSetUsual ? () => _pickDefaultRule(context, scheduleRule) : null,
    );
  }

  Future<void> _pickDefaultRule(
    BuildContext context,
    RecurrenceRule scheduleRule,
  ) async {
    final response =
        await showModalBottomSheet<(RecurrenceRule?, ReplyOptions?)>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => DefaultRuleActionSheet(
            memberName: isYou ? null : name,
            eventName: eventName,
            scheduleRule: scheduleRule,
            recurrenceRule: defaultRule?.recurrenceRule,
            replyOption: defaultRule?.selectedOption,
          ),
        );
    if (response == null) return;
    final (recurrenceRule, replyOption) = response;
    if (recurrenceRule == null) return;
    onDefaultRuleChanged?.call(recurrenceRule, replyOption);
  }
}
