import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:rrule/rrule.dart';

class ScheduleMemberTile extends StatelessWidget {
  final String name;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final DefaultRule? defaultRule;
  final Function(ReplyOptions?)? onReplyChanged;
  final Function(RecurrenceRule?, ReplyOptions?)? onDefaultRuleChanged;

  const ScheduleMemberTile({
    super.key,
    required this.name,
    this.reply,
    this.defaultReply,
    this.defaultRule,
    this.onReplyChanged,
    this.onDefaultRuleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      trailing: ReplyButtons(
        reply: reply,
        defaultReply: defaultReply,
        onReplyChanged: (reply) => onReplyChanged?.call(reply),
      ),
      onTap: () => _confirmDefaultRule(context),
    );
  }

  /// Shows a confirmation action sheet to define the default reply.
  _confirmDefaultRule(BuildContext context) async {
    RecurrenceRule? selectedRecurrenceRule = defaultRule?.recurrenceRule;
    ReplyOptions? selectedOption = defaultRule?.selectedOption;
    final response = await _confirmDefaultRuleActionSheet(
      context,
      (BuildContext context) => DefaultRuleActionSheet(
        recurrenceRule: selectedRecurrenceRule,
        replyOption: selectedOption,
      ),
    );

    if (response != null) {
      final (recurrenceRule, replyOption) = response;
      if (recurrenceRule == null) return;

      onDefaultRuleChanged?.call(recurrenceRule, replyOption);
    }
  }

  Future<(RecurrenceRule?, ReplyOptions?)?> _confirmDefaultRuleActionSheet<T>(
      BuildContext context, WidgetBuilder builder) async {
    return showModalBottomSheet<(RecurrenceRule?, ReplyOptions?)>(
        context: context, builder: builder);
  }
}
