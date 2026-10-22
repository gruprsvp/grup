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

  /// The day shown, and its events with everyone's answers.
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final List<ScheduleInstanceSummary> instances;
  final OnReplyChangedCallback? onReplyChanged;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
    required this.isAdmin,
    required this.date,
    required this.onDateChanged,
    required this.instances,
    this.group,
    this.loading = false,
    this.error,
    this.onRetry,
    this.onReplyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final groupName = group?.displayName ?? l10n.loading;
    final groupImage = group?.picture;
    final groupDescription = group?.description;
    final error = this.error;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            title: Text(groupName),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  DateDropdown(date: date, onDateChanged: onDateChanged),
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
              child: Column(
                children: [
                  if (groupImage != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Hero(
                        tag: groupImage,
                        child: ProfilePicture(
                          image: NetworkImage(groupImage),
                          icon: Icons.group,
                          radius: 128,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  if (groupDescription != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(groupDescription),
                    ),
                ],
              ),
            ),
        ],
        body: DayPager(
          date: date,
          onDateChanged: onDateChanged,
          child: SchedulesList(
            groupId: groupId,
            schedules: instances,
            isAdmin: isAdmin,
            onReplyChanged: onReplyChanged,
          ),
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => GroupManageRoute(groupId: groupId).push(context),
              label: Text(l10n.groupManage),
              icon: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
