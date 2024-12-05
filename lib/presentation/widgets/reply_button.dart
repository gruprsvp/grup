import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';

class ReplyButtons extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReplyOption;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const ReplyButtons({
    super.key,
    this.reply,
    this.defaultReplyOption,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YesButton(
              reply: reply,
              defaultReplyOption: defaultReplyOption,
              onReplyChanged: onReplyChanged,
            ),
            SizedBox(width: 8),
            NoButton(
              reply: reply,
              defaultReplyOption: defaultReplyOption,
              onReplyChanged: onReplyChanged,
            ),
          ],
        ));
  }
}

class ReplyButton extends StatelessWidget {
  final ReplyOptions option;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReplyOption;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String tooltip;
  final Color activeColor;

  const ReplyButton({
    super.key,
    required this.option,
    this.reply,
    this.defaultReplyOption,
    this.onReplyChanged,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.tooltip,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.surface;

    final foregroundColor = WidgetStatePropertyAll<Color>(surfaceColor);
    final focusColor = WidgetStatePropertyAll<Color>(activeColor);

    final isActive = reply == option;
    final isDefault = defaultReplyOption == option && reply == null;

    if (isActive) {
      return IconButton.filled(
        icon: FaIcon(activeIcon),
        onPressed: () => onReplyChanged?.call(null),
        style: ButtonStyle(
          foregroundColor: foregroundColor,
          backgroundColor: focusColor,
        ),
        tooltip: tooltip,
      );
    } else if (isDefault) {
      return IconButton.outlined(
        style: ButtonStyle(
          foregroundColor: focusColor,
          side: WidgetStateProperty.all(BorderSide(color: activeColor)),
        ),
        icon: FaIcon(activeIcon),
        onPressed: () => onReplyChanged?.call(option),
        tooltip: tooltip,
      );
    } else {
      return IconButton.outlined(
        icon: FaIcon(inactiveIcon),
        onPressed: () => onReplyChanged?.call(option),
        tooltip: tooltip,
      );
    }
  }
}

class YesButton extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReplyOption;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const YesButton({
    super.key,
    this.reply,
    this.defaultReplyOption,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ReplyButton(
      option: ReplyOptions.yes,
      reply: reply,
      defaultReplyOption: defaultReplyOption,
      onReplyChanged: onReplyChanged,
      activeIcon: FontAwesomeIcons.solidThumbsUp,
      inactiveIcon: FontAwesomeIcons.thumbsUp,
      tooltip: l10n.yes,
      activeColor: Colors.green,
    );
  }
}

class NoButton extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReplyOption;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const NoButton({
    super.key,
    this.reply,
    this.defaultReplyOption,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ReplyButton(
      option: ReplyOptions.no,
      reply: reply,
      defaultReplyOption: defaultReplyOption,
      onReplyChanged: onReplyChanged,
      activeIcon: FontAwesomeIcons.solidThumbsDown,
      inactiveIcon: FontAwesomeIcons.thumbsDown,
      tooltip: l10n.no,
      activeColor: Colors.red,
    );
  }
}
