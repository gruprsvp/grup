import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';

/// A widget to display a list of groups and route to their details.
class GroupsList extends StatelessWidget {
  final Iterable<Group>? groups;

  /// A group's next event, shown under its name with who's coming.
  final NextEvent? Function(String groupId)? nextEvent;

  const GroupsList({super.key, this.groups, this.nextEvent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      // Clear of the "Create or join group" button over the last card.
      padding: const EdgeInsets.only(top: 4, bottom: 96),
      itemBuilder: (context, index) {
        final group = groups!.elementAt(index);
        final picture = group.picture;
        final displayName = group.displayName;
        final description = group.description;
        final next = nextEvent?.call(group.id);

        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Hero(
              tag: picture ?? group.hashCode,
              child: ProfilePicture(
                image: picture != null ? NetworkImage(picture) : null,
                icon: Icons.group,
                radius: 24,
                color: theme.colorScheme.secondary,
              ),
            ),
            title: Hero(
              tag: group,
              child: Text(
                displayName,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: description == null && next == null
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (description != null)
                        Text(
                          description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                        ),
                      if (next != null) ...[
                        const SizedBox(height: 8),
                        _NextEventLine(next: next),
                      ],
                    ],
                  ),
            onTap: () =>
                GroupDetailsRoute(groupId: group.id.toString()).go(context),
          ),
        );
      },
      itemCount: groups?.length ?? 0,
    );
  }
}

/// "Next: Five-a-side, Tue, Oct 27 · 6:30 PM · **4 coming** +1 usually".
class _NextEventLine extends StatelessWidget {
  const _NextEventLine({required this.next});

  final NextEvent next;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final (:event, :counted) = next;
    final at = event.instanceDate;
    final when = [
      DateFormat.MMMEd(locale).format(at),
      DateFormat.jm(locale).format(at),
    ].join(' · ');
    final confirmed = event.confirmedYes;
    final usual = event.usualYes;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 8),
          child: Icon(
            Icons.event_outlined,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: l10n.nextEvent(event.displayName, when)),
                // Too far ahead for its answers to be loaded: no count, rather
                // than a wrong one.
                if (counted) ...[
                  const TextSpan(text: ' · '),
                  TextSpan(
                    text: keepTogether(l10n.eventComing(confirmed)),
                    // Quiet when nobody's coming yet.
                    style: confirmed > 0 ? theme.textTheme.labelLarge : null,
                  ),
                  if (usual > 0)
                    TextSpan(
                      text: ' ${keepTogether(l10n.eventUsually(usual))}',
                    ),
                ],
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
