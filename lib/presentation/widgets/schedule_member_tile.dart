import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:rrule/rrule.dart';

class ScheduleMemberTile extends StatelessWidget {
  final String name;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReplyOption;
  final DefaultReply? defaultReply;
  final Function(ReplyOptions?)? onReplyChanged;
  final Function(RecurrenceRule?, ReplyOptions?)? onDefaultReplyChanged;

  const ScheduleMemberTile({
    super.key,
    required this.name,
    this.reply,
    this.defaultReplyOption,
    this.defaultReply,
    this.onReplyChanged,
    this.onDefaultReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: ReplyButtons(
        reply: reply,
        defaultReplyOption: defaultReplyOption,
        onReplyChanged: (reply) => onReplyChanged?.call(reply),
      ),
      onTap: () => _confirmDefaultReply(context),
    );
  }

  /// Shows a confirmation action sheet to define the default reply.
  _confirmDefaultReply(BuildContext context) async {
    RecurrenceRule? selectedRecurrenceRule = defaultReply?.recurrenceRule;
    ReplyOptions? selectedOption = defaultReply?.selectedOption;
    final response = await _confirmDefaultReplyActionSheet(
      context,
      (BuildContext context) => DefaultReplyActionSheet(
        recurrenceRule: selectedRecurrenceRule,
        replyOption: selectedOption,
      ),
    );

    if (response != null) {
      final (recurrenceRule, replyOption) = response;
      if (recurrenceRule == null) return;

      onDefaultReplyChanged?.call(recurrenceRule, replyOption);
    }
  }

  Future<(RecurrenceRule?, ReplyOptions?)?> _confirmDefaultReplyActionSheet<T>(
      BuildContext context, WidgetBuilder builder) async {
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    return await (isCupertino
        ? showCupertinoModalPopup<(RecurrenceRule?, ReplyOptions?)>(
            context: context, builder: builder)
        : showModalBottomSheet<(RecurrenceRule?, ReplyOptions?)>(
            context: context, builder: builder));
  }
}
