import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:rrule/rrule.dart';

class ScheduleMemberTile extends StatefulWidget {
  final String name;
  final ReplyOptions? reply;
  final ReplyOptions? defaultReply;
  final DefaultRule? defaultRule;
  final Function(ReplyOptions?)? onReplyChanged;
  final Function(RecurrenceRule?, ReplyOptions)? onDefaultRuleChanged;

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
  State<ScheduleMemberTile> createState() => _ScheduleMemberTileState();
}

class _ScheduleMemberTileState extends State<ScheduleMemberTile> {
  RecurrenceRule? selectedDefaultOption;
  RecurrenceRule? previousDefaultOption;

  @override
  void initState() {
    super.initState();

    selectedDefaultOption = widget.defaultRule?.recurrenceRule;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      trailing: ReplyButtons(
        reply: widget.reply,
        defaultReply: widget.defaultReply,
        onReplyChanged: (reply) => widget.onReplyChanged?.call(reply),
      ),
      onLongPress: () =>
          _confirmDefaultRule(context, widget.reply ?? ReplyOptions.yes),
    );
  }

  /// Shows a confirmation action sheet to define the default reply.
  _confirmDefaultRule(BuildContext context, ReplyOptions reply) async {
    setState(() {
      previousDefaultOption = selectedDefaultOption;
    });

    final isConfirmed = await _confirmDefaultRuleActionSheet(
      context,
      (BuildContext context) => DefaultRuleActionSheet(
        selectedDefaultOption: selectedDefaultOption,
        onOptionTap: (option) {
          if (option == null) {
            context.pop(false);
            return;
          }

          setState(() {
            selectedDefaultOption =
                (selectedDefaultOption != option) ? option : null;
          });
          context.pop(true);
        },
      ),
    );

    if (isConfirmed == true) {
      widget.onDefaultRuleChanged?.call(selectedDefaultOption, reply);

      return;
    }

    setState(() {
      selectedDefaultOption = previousDefaultOption;
    });
  }

  Future<bool?> _confirmDefaultRuleActionSheet(
      BuildContext context, WidgetBuilder builder) async {
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    return await (isCupertino
        ? showCupertinoModalPopup<bool>(context: context, builder: builder)
        : showModalBottomSheet<bool>(context: context, builder: builder));
  }
}
