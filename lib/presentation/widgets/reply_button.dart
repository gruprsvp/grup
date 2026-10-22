import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';

/// "Yes" green, dark enough for a white icon (5.1:1) and visible as an
/// outline on light and dark surfaces alike (WCAG asks 3:1 for icons).
/// "No" uses the theme's error colours, which Material keeps accessible.
final yesColor = Colors.green.shade800;

class ReplyButtons extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const ReplyButtons({
    super.key,
    this.reply,
    this.defaultReply,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        YesButton(
          reply: reply,
          defaultReply: defaultReply,
          onReplyChanged: onReplyChanged,
        ),
        NoButton(
          reply: reply,
          defaultReply: defaultReply,
          onReplyChanged: onReplyChanged,
        ),
      ],
    );
  }
}

class ReplyButton extends StatelessWidget {
  final ReplyOptions option;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final FaIconData activeIcon;
  final FaIconData inactiveIcon;
  final String tooltip;
  final Color activeColor;

  /// The icon's colour on [activeColor].
  final Color onActiveColor;

  const ReplyButton({
    super.key,
    required this.option,
    this.reply,
    this.defaultReply,
    this.onReplyChanged,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.tooltip,
    required this.activeColor,
    required this.onActiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = WidgetStatePropertyAll<Color>(onActiveColor);
    final focusColor = WidgetStatePropertyAll<Color>(activeColor);

    final isActive = reply == option;
    final isDefault = defaultReply == option && reply == null;

    final onReplyChanged = this.onReplyChanged;
    // Without a callback the buttons show the answer but are disabled.
    VoidCallback? answer(ReplyOptions? reply) =>
        onReplyChanged == null ? null : () => onReplyChanged(reply);

    if (isActive) {
      return IconButton.filled(
        icon: FaIcon(activeIcon),
        // Tapping the current answer clears it.
        onPressed: answer(null),
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
        onPressed: answer(option),
        tooltip: tooltip,
      );
    } else {
      return IconButton.outlined(
        icon: FaIcon(inactiveIcon),
        onPressed: answer(option),
        tooltip: tooltip,
      );
    }
  }
}

class YesButton extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const YesButton({
    super.key,
    this.reply,
    this.defaultReply,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ReplyButton(
      option: ReplyOptions.yes,
      reply: reply,
      defaultReply: defaultReply,
      onReplyChanged: onReplyChanged,
      activeIcon: FontAwesomeIcons.solidThumbsUp,
      inactiveIcon: FontAwesomeIcons.thumbsUp,
      tooltip: l10n.yes,
      activeColor: yesColor,
      onActiveColor: Colors.white,
    );
  }
}

class NoButton extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const NoButton({
    super.key,
    this.reply,
    this.defaultReply,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ReplyButton(
      option: ReplyOptions.no,
      reply: reply,
      defaultReply: defaultReply,
      onReplyChanged: onReplyChanged,
      activeIcon: FontAwesomeIcons.solidThumbsDown,
      inactiveIcon: FontAwesomeIcons.thumbsDown,
      tooltip: l10n.no,
      activeColor: Theme.of(context).colorScheme.error,
      onActiveColor: Theme.of(context).colorScheme.onError,
    );
  }
}
