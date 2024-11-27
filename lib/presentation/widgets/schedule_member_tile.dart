import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:rrule/rrule.dart';

class ScheduleMemberTile extends StatefulWidget {
  final String name;
  final ReplyOptions? myReply;
  final RecurrenceRule? myDefaultOption;
  final Function(ReplyOptions?)? onReplyChanged;
  final Function(RecurrenceRule?, ReplyOptions)? onDefaultReplyChanged;

  const ScheduleMemberTile({
    super.key,
    required this.name,
    this.myReply,
    this.myDefaultOption,
    this.onReplyChanged,
    this.onDefaultReplyChanged,
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

    selectedDefaultOption = widget.myDefaultOption;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name),
      trailing: ReplyButton(
          myReply: widget.myReply,
          onReplyChanged: (reply) => widget.onReplyChanged?.call(reply),
          onDefaultReplyChanged: (reply) =>
              _confirmDefaultReply(context, reply)),
    );
  }

  /// Shows a confirmation action sheet to define the default reply.
  _confirmDefaultReply(BuildContext context, ReplyOptions reply) async {
    final nav = Navigator.of(context);

    setState(() {
      previousDefaultOption = selectedDefaultOption;
    });

    final isConfirmed = await _confirmDefaultReplyActionSheet(
      context,
      (BuildContext context) => DefaultReplyActionSheet(
        selectedDefaultOption: selectedDefaultOption,
        onOptionTap: (option) {
          if (option == null) {
            nav.pop(false);
            return;
          }

          setState(() {
            selectedDefaultOption =
                (selectedDefaultOption != option) ? option : null;
          });
          nav.pop(true);
        },
      ),
    );

    if (isConfirmed == true) {
      widget.onDefaultReplyChanged?.call(selectedDefaultOption, reply);

      return;
    }

    setState(() {
      selectedDefaultOption = previousDefaultOption;
    });
  }

  Future<bool?> _confirmDefaultReplyActionSheet(
      BuildContext context, WidgetBuilder builder) async {
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    return await (isCupertino
        ? showCupertinoModalPopup<bool>(context: context, builder: builder)
        : showModalBottomSheet<bool>(context: context, builder: builder));
  }
}
