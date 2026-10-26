import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';

class ScheduleTile extends StatelessWidget {
  final ScheduleInstanceSummary schedule;
  final ValueChanged<ReplyOptions?>? onReplyChanged;
  final ValueChanged<ScheduleInstanceSummary>? onScheduleTapped;

  /// Whether this event is open next to the list.
  final bool selected;

  /// When changes to the answers closed, if they have: only admins answer
  /// then, and nobody clears an answer.
  final DateTime? closedAt;
  final bool isAdmin;

  const ScheduleTile({
    super.key,
    required this.schedule,
    this.onReplyChanged,
    this.onScheduleTapped,
    this.selected = false,
    this.closedAt,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final jm = DateFormat.jm(Localizations.localeOf(context).toString());
    final time = jm.format(schedule.instanceDate);
    final closedAt = this.closedAt;
    final confirmed = schedule.confirmedYes;
    final usual = schedule.usualYes;

    // The time orders the day; who's coming is why the row is here.
    // The open event is marked by its background, not by recolouring the
    // row (as ListTile.selected would): its answer colours mean answers.
    return Semantics(
      selected: selected,
      child: Card(
        color: selected
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        child: ListTile(
          contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 8),
          title: Text(
            schedule.displayName,
            style: textTheme.titleMedium,
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
                if (closedAt != null)
                  TextSpan(
                    text: '\n${l10n.changesClosedAt(jm.format(closedAt))}',
                  ),
              ],
            ),
          ),
          trailing: ReplyButtons(
            reply: schedule.myReply,
            defaultReply: schedule.myDefaultReply,
            onReplyChanged: closedAt != null && !isAdmin
                ? null
                : onReplyChanged,
            canClear: closedAt == null,
          ),
          onTap: () => onScheduleTapped?.call(schedule),
        ),
      ),
    );
  }
}
