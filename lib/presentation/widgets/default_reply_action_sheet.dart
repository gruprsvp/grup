import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';

/// A widget to display the default reply options.
class DefaultReplyActionSheet extends StatelessWidget {
  final RecurrenceRule? selectedDefaultOption;
  final Function(RecurrenceRule?) onOptionTap;

  const DefaultReplyActionSheet({
    super.key,
    this.selectedDefaultOption,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    final options = [
      (CommonRecurrenceRules.daily, l10n.defaultRepliesDaily),
      (CommonRecurrenceRules.weekdays, l10n.defaultRepliesWeekdays),
      (CommonRecurrenceRules.weekends, l10n.defaultRepliesWeekends),
    ];

    final actions = options
        .map((option) =>
            _buildActionSheetAction(context, onOptionTap, option.$2, option.$1))
        .toList();

    return (isCupertino)
        ? CupertinoActionSheet(
            title: Text(l10n.defaultReplies),
            message: Text(l10n.defaultRepliesDescription),
            actions: actions,
            cancelButton: _buildActionSheetAction(
                context, onOptionTap, l10n.cancel, null),
          )
        : Wrap(
            children: [
              _buildActionSheetHeader(context),
              ...actions,
              _buildActionSheetAction(context, onOptionTap, l10n.cancel, null),
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
            child: Text(l10n.defaultReplies),
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
            child: Text(l10n.defaultRepliesDescription),
          ),
        )
      ],
    );
  }

  Widget _buildActionSheetAction(BuildContext context,
      Function(RecurrenceRule?) onTap, String text, RecurrenceRule? option) {
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;
    final checked =
        selectedDefaultOption != null && selectedDefaultOption == option;
    return (isCupertino)
        ? CupertinoActionSheetAction(
            onPressed: () => onTap(option),
            child: Row(
              children: [
                ...((checked)
                    ? [
                        Icon(CupertinoIcons.check_mark, size: 18),
                        SizedBox(width: 10),
                      ]
                    : []),
                Text(text),
              ],
            ),
          )
        : ListTile(
            onTap: () => onTap(option),
            leading: (checked) ? Icon(Icons.check) : null,
            title: Text(text),
          );
  }
}
