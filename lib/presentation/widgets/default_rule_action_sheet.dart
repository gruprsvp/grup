import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// Sets someone's usual answer to a recurring event. Pops `(rule, answer)`;
/// a `null` answer clears it.
class DefaultRuleActionSheet extends StatelessWidget {
  /// Whose usual answer this is; `null` for the user's own.
  final String? memberName;
  final String eventName;

  /// How the event recurs: "every time" means every one of these.
  final RecurrenceRule scheduleRule;
  final RecurrenceRule? recurrenceRule;
  final ReplyOptions? replyOption;

  const DefaultRuleActionSheet({
    super.key,
    this.memberName,
    required this.eventName,
    required this.scheduleRule,
    this.recurrenceRule,
    this.replyOption,
  });

  /// The rules worth offering for [scheduleRule]: every time, and for a daily
  /// event, weekdays or weekends. Other choices would match no occurrence.
  static List<(RecurrenceRule, String)> options(
    AppLocalizations l10n,
    RecurrenceRule scheduleRule, [
    RecurrenceRule? current,
  ]) {
    final options = [
      (scheduleRule, l10n.usualEveryTime),
      if (scheduleRule == CommonRecurrenceRules.daily) ...[
        (CommonRecurrenceRules.weekdays, l10n.defaultRulesWeekdays),
        (CommonRecurrenceRules.weekends, l10n.defaultRulesWeekends),
      ],
    ];
    // A rule set some other way stays visible, so it can be changed.
    if (current != null && !options.any((o) => o.$1 == current)) {
      options.add((current, recurrenceLabel(l10n, current)));
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final memberName = this.memberName;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memberName == null
                        ? l10n.usualAnswerYours
                        : l10n.usualAnswerFor(memberName),
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    eventName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            for (final (rule, text) in options(
              l10n,
              scheduleRule,
              recurrenceRule,
            ))
              ListTile(
                title: Text(text),
                trailing: ReplyButtons(
                  reply: recurrenceRule == rule ? replyOption : null,
                  onReplyChanged: (reply) =>
                      Navigator.pop(context, (rule, reply)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.defaultRulesExplanation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
