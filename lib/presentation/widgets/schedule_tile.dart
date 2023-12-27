import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:parousia/models/models.dart';

class ScheduleTile extends StatelessWidget {
  final timeFormat = DateFormat.jm();
  final ScheduleInstance schedule;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final ValueChanged<ScheduleInstance>? onScheduleTapped;

  ScheduleTile({
    super.key,
    required this.schedule,
    this.onReplyChanged,
    this.onScheduleTapped,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(schedule.displayName),
      subtitle: Text(timeFormat.format(schedule.eventDate)),
      trailing: Badge.count(
        count: schedule.yesCount,
        alignment: Alignment.topLeft,
        child: SegmentedButton<ReplyOptions>(
          segments: [
            ButtonSegment(value: ReplyOptions.yes, label: Text(l10n.yes)),
            ButtonSegment(value: ReplyOptions.no, label: Text(l10n.no)),
          ],
          selected: schedule.myReply != null ? {schedule.myReply!} : {},
          onSelectionChanged: (value) =>
              onReplyChanged?.call(value.firstOrNull),
          emptySelectionAllowed: true,
          style: const ButtonStyle(
            visualDensity: VisualDensity.comfortable,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
      onTap: () => onScheduleTapped?.call(schedule),
    );
  }
}
