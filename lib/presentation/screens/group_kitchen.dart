import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

/// A day of a group's events as the kitchen needs it: how many are coming,
/// who, and who changed their answer late (kitchen_view).
class GroupKitchenScreen extends StatelessWidget {
  const GroupKitchenScreen({
    super.key,
    required this.available,
    required this.loading,
    required this.date,
    required this.onDateChanged,
    required this.events,
    required this.nameOf,
    this.group,
    this.error,
    this.onRetry,
    this.onRefresh,
    this.onPrint,
  });

  final Group? group;

  /// The group's plan includes the kitchen view on this platform.
  final bool available;
  final bool loading;
  final Exception? error;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final List<KitchenEvent> events;
  final String Function((Member, Profile?) member) nameOf;
  final VoidCallback? onPrint;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = this.error;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.kitchenTitle),
        actions: [
          if (available)
            IconButton(
              icon: const Icon(Icons.print_outlined),
              tooltip: l10n.kitchenPrint,
              onPressed: events.isEmpty ? null : onPrint,
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
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
                child: DateDropdown(date: date, onDateChanged: onDateChanged),
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
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: onRefresh ?? () async {},
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            if (loading) const LinearProgressIndicator(),
            if (error != null) ErrorNotice(error: error, onRetry: onRetry),
            if (!available && !loading)
              _Message(l10n.featureUnavailable)
            else if (available && events.isEmpty && !loading)
              _Message(l10n.noEventsThisDay)
            else if (available)
              for (final event in events)
                _KitchenEventCard(event: event, nameOf: nameOf),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    ),
  );
}

class _KitchenEventCard extends StatelessWidget {
  const _KitchenEventCard({required this.event, required this.nameOf});

  final KitchenEvent event;
  final String Function((Member, Profile?) member) nameOf;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final time = DateFormat.jm(Localizations.localeOf(context).toString())
        .format(event.instance.instanceDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              '$time · ${event.schedule.displayName}',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              keepTogether(l10n.eventComing(event.coming.length)),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              [
                keepTogether(l10n.kitchenMembers(event.members)),
                keepTogether(l10n.kitchenGuests(event.guests)),
              ].join(' · '),
            ),
            Text(
              [
                keepTogether(l10n.eventOut(event.no)),
                keepTogether(l10n.eventNoReply(event.noReply)),
              ].join(' · '),
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 8),
            Text(
              event.coming.isEmpty
                  ? l10n.kitchenNobody
                  : event.coming.map(nameOf).join(', '),
            ),
            if (event.late.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${l10n.kitchenLate}: ',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: event.late.map(nameOf).join(', ')),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
