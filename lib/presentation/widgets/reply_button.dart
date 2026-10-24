import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parousia/models/models.dart';

/// "Yes" green, dark enough for a white icon (5.1:1) and visible as an
/// outline on light and dark surfaces alike (WCAG asks 3:1 for icons).
/// "No" uses the theme's error colours, which Material keeps accessible.
final yesColor = Colors.green.shade800;

/// Icons and text on [yesColor].
const onYesColor = Colors.white;

/// Keeps a short phrase ("5 coming") on one line when the text wraps.
String keepTogether(String phrase) => phrase.replaceAll(' ', '\u00A0');

class ReplyButtons extends StatelessWidget {
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;

  /// Without it, the answer is shown but can't be changed.
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
    final isActive = reply == option;
    final isDefault = defaultReply == option && reply == null;

    final onReplyChanged = this.onReplyChanged;
    if (onReplyChanged == null) return _readOnly(isActive, isDefault);

    if (isActive) {
      return IconButton.filled(
        icon: FaIcon(activeIcon),
        isSelected: true,
        // Tapping the current answer clears it.
        onPressed: () => onReplyChanged(null),
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(onActiveColor),
          backgroundColor: WidgetStatePropertyAll(activeColor),
        ),
        tooltip: tooltip,
      );
    }
    final icon = FaIcon(isDefault ? activeIcon : inactiveIcon);
    return IconButton.outlined(
      // The tooltip stays "Yes"/"No"; screen readers also hear it's the usual
      // answer, not a real one. Inside the button, so it lands on its node.
      icon: isDefault
          ? Semantics(
              value: AppLocalizations.of(context)!.usualAnswer,
              child: icon,
            )
          : icon,
      isSelected: false,
      onPressed: () => onReplyChanged(option),
      style: isDefault
          ? ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(activeColor),
              side: WidgetStatePropertyAll(BorderSide(color: activeColor)),
            )
          : null,
      tooltip: tooltip,
    );
  }

  /// The answer as a mark rather than a disabled button: full contrast, not
  /// focusable, and nothing at all when there's no answer. The row's label
  /// tells screen readers the answer.
  Widget _readOnly(bool isActive, bool isDefault) => ExcludeSemantics(
    child: SizedBox.square(
      // The slot an enabled button takes, so rows line up.
      dimension: 48,
      child: !isActive && !isDefault
          ? null
          : Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  shape: CircleBorder(side: BorderSide(color: activeColor)),
                  color: isActive ? activeColor : null,
                ),
                child: Center(
                  child: FaIcon(
                    activeIcon,
                    size: 20,
                    color: isActive ? onActiveColor : activeColor,
                  ),
                ),
              ),
            ),
    ),
  );
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
      onActiveColor: onYesColor,
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
