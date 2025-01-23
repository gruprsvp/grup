import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

class DefaultRuleActionSheet extends StatelessWidget {
  final RecurrenceRule? recurrenceRule;
  final ReplyOptions? replyOption;

  const DefaultRuleActionSheet({
    super.key,
    this.recurrenceRule,
    this.replyOption,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final options = [
      (CommonRecurrenceRules.daily, l10n.defaultRulesDaily),
      (CommonRecurrenceRules.weekdays, l10n.defaultRulesWeekdays),
      (CommonRecurrenceRules.weekends, l10n.defaultRulesWeekends),
    ];

    final actions = [
      for (final (rule, text) in options)
        _buildActionSheetAction(
          context,
          text: text,
          option: rule,
          isSelected: recurrenceRule == rule,
          onTap: (replyOption) {
            Navigator.pop(context, (rule, replyOption));
          },
        ),
    ];

    return Wrap(
      children: [
        _buildActionSheetHeader(context),
        ...actions,
        _buildExplanationWidget(context),
      ],
    );
  }

  Widget _buildActionSheetHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textAlign = TextAlign.start;
    final defaultPadding = 16.0;
    final betweenPadding = 4.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding,
              bottom: betweenPadding),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!,
            textAlign: textAlign,
            child: Text(l10n.defaultRules),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: betweenPadding,
              bottom: defaultPadding),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleMedium!,
            textAlign: textAlign,
            child: Text(l10n.defaultRulesDescription),
          ),
        ),
      ],
    );
  }

  Widget _buildActionSheetAction(
    BuildContext context, {
    required String text,
    required bool isSelected,
    required void Function(ReplyOptions?) onTap,
    RecurrenceRule? option,
  }) {
    return ListTile(
      title: Text(text),
      trailing: ReplyButtons(
        reply: isSelected ? replyOption : null,
        onReplyChanged: (reply) => onTap(reply),
      ),
    );
  }

  Widget _buildExplanationWidget(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        l10n.defaultRulesExplanation,
        style: Theme.of(context).textTheme.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
