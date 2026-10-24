import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:parousia/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final time = DateFormat.jm(Localizations.localeOf(context).toString())
        .format(schedule.instanceDate);
    final confirmed = schedule.confirmedYes;
    final usual = schedule.usualYes;

    // The time orders the day; who's coming is why the row is here.
    return ListTile(
      title: Text(
        schedule.displayName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$time · '),
            TextSpan(
              text: keepTogether(l10n.eventComing(confirmed)),
              // Quiet when nobody's coming yet.
              style: confirmed > 0 ? textTheme.labelLarge : null,
            ),
            if (usual > 0)
              TextSpan(text: ' ${keepTogether(l10n.eventUsually(usual))}'),
          ],
        ),
      ),
      trailing: ReplyButtons(
        reply: schedule.myReply,
        defaultReply: schedule.myDefaultReply,
        onReplyChanged: onReplyChanged,
      ),
      onTap: () => onScheduleTapped?.call(schedule),
    );
  }
}
