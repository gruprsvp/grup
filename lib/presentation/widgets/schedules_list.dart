import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:styled_text/styled_text.dart';

typedef OnReplyChangedCallback = void Function(
  ScheduleInstanceSummary,
  ReplyOptions?,
);

class SchedulesList extends StatelessWidget {
  final List<ScheduleInstanceSummary>? schedules;
  final OnReplyChangedCallback? onReplyChanged;
  final Future<void> Function()? onRefresh;
  final String groupId;
  final bool isAdmin;

  /// Whether the group has events on other days, and the first one after
  /// this day, for an empty day to point at.
  final bool hasSchedules;
  final (Schedule, DateTime)? next;

  /// Whether it's unknown if the group has events (loading them failed):
  /// an empty day then shows nothing rather than a guess.
  final bool unknown;
  final ValueChanged<DateTime>? onDateChanged;

  /// Whether anyone but the user is in the group. An admin sees what's left
  /// to set up until the group has events and people.
  final bool hasOtherMembers;
  final ValueSetter<Schedule>? onCreateSchedule;

  const SchedulesList({
    super.key,
    this.schedules,
    this.onReplyChanged,
    this.onRefresh,
    required this.groupId,
    required this.isAdmin,
    this.hasSchedules = false,
    this.next,
    this.onDateChanged,
    this.unknown = false,
    this.hasOtherMembers = true,
    this.onCreateSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final schedules = this.schedules;
    if (schedules == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final setup = isAdmin && !unknown && (!hasSchedules || !hasOtherMembers)
        ? GroupSetup(
            hasEvents: hasSchedules,
            hasMembers: hasOtherMembers,
            onAddEvent: () => _addEvent(context),
            onInvite: () => GroupManageRoute(groupId: groupId).go(context),
          )
        : null;

    return RefreshIndicator.adaptive(
      onRefresh: onRefresh ?? () async {},
      child: schedules.isNotEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              // Clear of the "Manage group" button over the last row.
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                for (final schedule in schedules)
                  ScheduleTile(
                    schedule: schedule,
                    onReplyChanged: onReplyChanged == null
                        ? null
                        : (reply) => onReplyChanged!(schedule, reply),
                    onScheduleTapped: (schedule) => GroupScheduleDetailsRoute(
                      groupId: schedule.groupId,
                      scheduleId: schedule.scheduleId,
                      at: schedule.instanceDate,
                    ).go(context),
                  ),
                if (setup != null) ...[const Divider(), setup],
              ],
            )
          // Scrollable, so pull-to-refresh works on an empty day too.
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: unknown
                      ? const SizedBox.shrink()
                      : hasSchedules
                      ? Column(children: [_emptyDay(context), ?setup])
                      : setup ?? _emptyGroup(context),
                ),
              ],
            ),
    );
  }

  /// A day without events, in a group that has them on other days.
  Widget _emptyDay(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final next = this.next;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            l10n.noEventsThisDay,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          if (next case (final schedule, final at)) ...[
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                l10n.nextEvent(
                  schedule.displayName,
                  DateFormat.MMMEd(Localizations.localeOf(context).toString())
                      .format(at),
                ),
              ),
              // Occurrences carry the wall-clock time in UTC fields.
              onPressed: () =>
                  onDateChanged?.call(DateTime(at.year, at.month, at.day)),
            ),
          ],
        ],
      ),
    );
  }

  /// A group with no events at all, for a member: an admin sees [GroupSetup].
  Widget _emptyGroup(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      image: 'add-events.webp',
      text: StyledText(
        text: l10n.groupEmptyEventsUser,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Future<void> _addEvent(BuildContext context) async {
    final schedule = await GroupScheduleCreateRoute(groupId: groupId)
        .push<Schedule>(context);
    // Null when the user backed out without saving.
    if (schedule != null) onCreateSchedule?.call(schedule);
  }
}
