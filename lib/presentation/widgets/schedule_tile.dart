import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/presentation/widgets/widgets.dart';

class ScheduleTile extends StatelessWidget {
  final timeFormat = DateFormat.jm();
  final ScheduleInstanceSummary scheduleInstance;
  final Function(Reply?, ReplyOptions?) onReplyChanged;
  final ValueChanged<ScheduleInstanceSummary>? onScheduleTapped;

  ScheduleTile({
    super.key,
    required this.scheduleInstance,
    required this.onReplyChanged,
    this.onScheduleTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(scheduleInstance.displayName),
      subtitle: Text(timeFormat.format(scheduleInstance.instanceDate)),
      trailing: Badge.count(
        count: scheduleInstance.yesCount,
        backgroundColor: Colors.green,
        alignment: Alignment.topLeft,
        child: ReplyButtons(
          reply: scheduleInstance.myReply?.selectedOption,
          defaultReply: scheduleInstance.myDefaultReply?.selectedOption,
          onReplyChanged: (replyOption) =>
              onReplyChanged.call(scheduleInstance.myReply, replyOption),
        ),
      ),
      onTap: () => onScheduleTapped?.call(scheduleInstance),
    );
  }
}
