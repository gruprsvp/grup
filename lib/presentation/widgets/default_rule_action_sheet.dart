import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// A widget to display the default reply options.
class DefaultRuleActionSheet extends StatelessWidget {
  final RecurrenceRule? selectedDefaultOption;
  final ValueSetter<RecurrenceRule?> onOptionTap;

  const DefaultRuleActionSheet({
    super.key,
    this.selectedDefaultOption,
    required this.onOptionTap,
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
      for (final (rrule, text) in options)
        _buildActionSheetAction(
          context,
          onTap: onOptionTap,
          text: text,
          option: rrule,
        ),
    ];

    if (_isIOS(context)) {
      return CupertinoActionSheet(
        title: Text(l10n.defaultRules),
        message: Text(l10n.defaultRulesDescription),
        actions: actions,
        cancelButton: _buildActionSheetAction(
          context,
          onTap: onOptionTap,
          text: l10n.cancel,
        ),
      );
    }

    return Wrap(
      children: [
        _buildActionSheetHeader(context),
        ...actions,
        _buildActionSheetAction(
          context,
          onTap: onOptionTap,
          text: l10n.cancel,
        ),
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
        )
      ],
    );
  }

  Widget _buildActionSheetAction(
    BuildContext context, {
    required ValueSetter<RecurrenceRule?> onTap,
    required String text,
    RecurrenceRule? option,
  }) {
    final checked =
        selectedDefaultOption != null && selectedDefaultOption == option;

    if (_isIOS(context)) {
      return CupertinoActionSheetAction(
        onPressed: () => onTap(option),
        child: Row(
          children: [
            if (checked) ...[
              Icon(CupertinoIcons.check_mark, size: 18),
              SizedBox(width: 10),
            ],
            Text(text),
          ],
        ),
      );
    }

    return ListTile(
      onTap: () => onTap(option),
      leading: (checked) ? Icon(Icons.check) : null,
      title: Text(text),
    );
  }

  bool _isIOS(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.iOS;
}
