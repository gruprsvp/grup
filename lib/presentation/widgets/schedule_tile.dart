import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:timezone/timezone.dart';

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

  Future<String> _getSubtitle() async {
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    if (schedule.timezone == localTimeZone) {
      return timeFormat.format(schedule.instanceDate);
    }

    final date = schedule.instanceDate;
    final remoteLocation = getLocation(schedule.timezone);
    final remoteTime = TZDateTime(remoteLocation, date.year, date.month,
        date.day, date.hour, date.minute);
    final localTime =
        TZDateTime.from(remoteTime.toUtc(), getLocation(localTimeZone));
    return timeFormat.format(localTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(schedule.displayName),
      subtitle: FutureBuilder<String>(
          future: _getSubtitle(),
          builder: (context, snapshot) => Text(snapshot.data ?? '')),
      trailing: Badge.count(
        count: schedule.yesCount,
        backgroundColor: Colors.green,
        alignment: Alignment.topLeft,
        child: ReplyButtons(
          reply: schedule.myReply,
          defaultReply: schedule.myDefaultReply,
          onReplyChanged: onReplyChanged,
        ),
      ),
      onTap: () => onScheduleTapped?.call(schedule),
    );
  }
}
