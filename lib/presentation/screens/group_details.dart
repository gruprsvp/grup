import 'dart:math';

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;
  final Group? group;
  final bool isAdmin;
  final bool loading;

  /// Why the group couldn't be loaded, if it couldn't.
  final Exception? error;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;

  /// The day shown, and a day's events with everyone's answers: a swipe
  /// shows the next or previous day as it comes in.
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final List<ScheduleInstanceSummary> Function(DateTime day) instancesOn;
  final OnReplyChangedCallback? onReplyChanged;

  /// Whether the group has events on any day, and the first after a day.
  final bool hasSchedules;
  final (Schedule, DateTime)? Function(DateTime day)? nextAfter;

  /// Whether anyone but the user is in the group: until then, an admin is
  /// shown what's left to set up.
  final bool hasOtherMembers;
  final ValueSetter<Schedule>? onCreateSchedule;

  /// The event open next to the list, if any.
  final ScheduleInstanceKey? selected;

  /// Replaces the back button's pop, if set.
  final VoidCallback? onBack;

  /// When changes to an event's answers closed, if they have.
  final DateTime? Function(ScheduleInstanceSummary instance)? closedAt;

  /// Whether the group's plan includes the kitchen view here.
  final bool showKitchen;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
    required this.isAdmin,
    required this.date,
    required this.onDateChanged,
    required this.instancesOn,
    this.group,
    this.loading = false,
    this.error,
    this.onRetry,
    this.onRefresh,
    this.onReplyChanged,
    this.hasSchedules = false,
    this.nextAfter,
    this.hasOtherMembers = true,
    this.onCreateSchedule,
    this.selected,
    this.onBack,
    this.closedAt,
    this.showKitchen = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final groupImage = group?.picture;
    final groupDescription = group?.description;
    final error = this.error;
    // Room for the date row at the user's text size (48dp buttons at 1×).
    final dateRowHeight =
        16.0 + max(48.0, MediaQuery.textScalerOf(context).scale(48));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            leading: onBack == null ? null : BackButton(onPressed: onBack),
            title: Text(group?.displayName ?? ''),
            actions: [
              if (showKitchen)
                IconButton(
                  icon: const Icon(Icons.soup_kitchen_outlined),
                  tooltip: l10n.kitchenTitle,
                  onPressed: () => GroupKitchenRoute(
                    groupId: groupId,
                    date: DateFormat('yyyy-MM-dd').format(date),
                  ).go(context),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(dateRowHeight),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          tooltip: l10n.previousDay,
                          onPressed: () =>
                              onDateChanged(date.copyWith(day: date.day - 1)),
                        ),
                        Flexible(
                          child: DateDropdown(
                            date: date,
                            onDateChanged: onDateChanged,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          tooltip: l10n.nextDay,
                          onPressed: () =>
                              onDateChanged(date.copyWith(day: date.day + 1)),
                        ),
                      ],
                    ),
                  ),
                  if (loading) const LinearProgressIndicator(),
                ],
              ),
            ),
          ),
          if (error != null)
            SliverToBoxAdapter(
              child: ErrorNotice(error: error, onRetry: onRetry),
            ),
          if (groupImage != null || groupDescription != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (groupImage != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Hero(
                          tag: groupImage,
                          child: ProfilePicture(
                            image: NetworkImage(groupImage),
                            icon: Icons.group,
                            radius: 32,
                            color: colorScheme.secondary,
                          ),
                        ),
                      ),
                    if (groupDescription != null)
                      Expanded(
                        child: Text(
                          groupDescription,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
        body: DayPager(
          date: date,
          onDateChanged: onDateChanged,
          itemBuilder: (context, day) {
            final instances = instancesOn(day);
            return SchedulesList(
              groupId: groupId,
              // Before the first load, or after it failed, an empty list says
              // nothing about the group: wait (or let the error speak) rather
              // than claim it has no events.
              schedules: instances.isEmpty && !hasSchedules && loading
                  ? null
                  : instances,
              unknown: instances.isEmpty && !hasSchedules && error != null,
              isAdmin: isAdmin,
              hasSchedules: hasSchedules,
              hasOtherMembers: hasOtherMembers,
              onCreateSchedule: onCreateSchedule,
              next: nextAfter?.call(day),
              onDateChanged: onDateChanged,
              onRefresh: onRefresh,
              onReplyChanged: onReplyChanged,
              selected: selected,
              closedAt: closedAt,
            );
          },
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => GroupManageRoute(groupId: groupId).go(context),
              label: Text(l10n.groupManage),
              icon: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
