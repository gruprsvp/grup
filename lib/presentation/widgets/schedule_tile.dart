import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';

class ScheduleTile extends StatelessWidget {
  final ScheduleInstanceSummary schedule;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final ValueChanged<ScheduleInstanceSummary>? onScheduleTapped;

  const ScheduleTile({
    super.key,
    required this.schedule,
    this.onReplyChanged,
    this.onScheduleTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(schedule.displayName),
      subtitle: Text(
        DateFormat.jm(Localizations.localeOf(context).toString())
            .format(schedule.instanceDate),
      ),
      trailing: Badge.count(
        count: schedule.yesCount,
        backgroundColor: yesColor,
        textColor: Colors.white,
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
