import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:timezone/browser.dart';

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

  Future<String> _getSubtitle() async {
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    if (scheduleInstance.schedule.timezone == localTimeZone) {
      return timeFormat.format(scheduleInstance.instanceDate);
    }

    final date = scheduleInstance.instanceDate;
    final remoteLocation = getLocation(scheduleInstance.schedule.timezone);
    final remoteTime = TZDateTime(remoteLocation, date.year, date.month,
        date.day, date.hour, date.minute);
    final localTime =
        TZDateTime.from(remoteTime.toUtc(), getLocation(localTimeZone));
    return timeFormat.format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(scheduleInstance.displayName),
      subtitle: FutureBuilder<String>(
          future: _getSubtitle(),
          builder: (context, snapshot) => Text(snapshot.data ?? '')),
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
