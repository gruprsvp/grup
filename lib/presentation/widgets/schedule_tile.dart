import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';

class ScheduleTile extends StatelessWidget {
  final timeFormat = DateFormat.jm();
  final ScheduleInstanceSummary schedule;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final ValueChanged<ScheduleInstanceSummary>? onScheduleTapped;

  ScheduleTile({
    super.key,
    required this.schedule,
    this.onReplyChanged,
    this.onScheduleTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(schedule.displayName),
      subtitle: Text(timeFormat.format(schedule.instanceDate)),
      trailing: Badge.count(
        count: schedule.yesCount,
        backgroundColor: Colors.green,
        alignment: Alignment.topLeft,
        child: ReplyButtons(
          reply: schedule.myReply,
          defaultReplyOption: schedule.myDefaultReplyOption,
          onReplyChanged: onReplyChanged,
        ),
      ),
      onTap: () => onScheduleTapped?.call(schedule),
    );
  }
}
