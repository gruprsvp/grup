import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';

class ReplyButton extends StatelessWidget {
  final ReplyOptions? myReply;
  final ValueChanged<ReplyOptions?>? onReplyChanged;

  const ReplyButton({
    super.key,
    this.onReplyChanged,
    this.myReply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SegmentedButton<ReplyOptions>(
      segments: [
        ButtonSegment(value: ReplyOptions.yes, label: Text(l10n.yes)),
        ButtonSegment(value: ReplyOptions.no, label: Text(l10n.no)),
      ],
      selected: myReply != null ? {myReply!} : {},
      onSelectionChanged: (value) => onReplyChanged?.call(value.firstOrNull),
      emptySelectionAllowed: true,
      style: const ButtonStyle(
        visualDensity: VisualDensity.comfortable,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
