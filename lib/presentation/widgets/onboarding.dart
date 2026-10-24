import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/widgets/widgets.dart';
import 'package:parousia/util/util.dart';
import 'package:styled_text/styled_text.dart';

/// Home before the user has any group: what GRUP shows, how to get there, and
/// the two ways in.
class HomeIntro extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onJoin;

  const HomeIntro({super.key, required this.onCreate, required this.onJoin});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                text: l10n.onboardingWelcome,
                style: theme.textTheme.headlineSmall,
                tags: {
                  'title': StyledTextTag(
                    style: GoogleFonts.sniglet(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                },
              ),
              const SizedBox(height: 4),
              Text(
                l10n.onboardingTagline,
                style: theme.textTheme.bodyLarge?.copyWith(color: muted),
              ),
              const SizedBox(height: 24),
              const _ExampleEvent(),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingExampleCaption,
                style: theme.textTheme.bodySmall?.copyWith(color: muted),
              ),
              const SizedBox(height: 24),
              SetupStep(
                number: 1,
                title: l10n.onboardingStepGroup,
                subtitle: l10n.onboardingStepGroupHint,
              ),
              SetupStep(
                number: 2,
                title: l10n.onboardingStepEvent,
                subtitle: l10n.onboardingStepEventHint,
              ),
              SetupStep(
                number: 3,
                title: l10n.onboardingStepInvite,
                subtitle: l10n.onboardingStepInviteHint,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Icons.group_add_outlined),
                    label: Text(l10n.onboardingStepGroup),
                  ),
                  TextButton.icon(
                    onPressed: onJoin,
                    icon: const Icon(Icons.waving_hand_outlined),
                    label: Text(l10n.onboardingJoin),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A made-up event as the group will see it: the headcount, then each
/// member's answer. Confirmed and usual answers are counted apart, as on a
/// real event.
class _ExampleEvent extends StatelessWidget {
  const _ExampleEvent();

  static const _people = [
    ('Alex', ReplyOptions.yes, null),
    ('Robin', null, ReplyOptions.yes),
    ('Sam', ReplyOptions.no, null),
  ];

  /// What the answer marks show, for screen readers.
  static String _status(AppLocalizations l10n, ReplyOptions? reply) =>
      switch (reply) {
        ReplyOptions.yes => l10n.answerComing,
        ReplyOptions.no => l10n.answerNotComing,
        null => l10n.answerUsuallyComing,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final time = DateFormat.jm(Localizations.localeOf(context).toString())
        .format(DateTime(2000, 1, 1, 19));

    // Not something to tap: an example, flat (lift means tappable).
    return IgnorePointer(
      child: Card.filled(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(l10n.onboardingExampleEvent),
                subtitle: Text('${l10n.recurrenceWeekly} · $time'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: keepTogether(l10n.eventComing(1)),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '  ${keepTogether(l10n.eventUsually(1))}',
                        style: textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(indent: 16, endIndent: 16),
              for (final (name, reply, usual) in _people)
                ListTile(
                  leading: CircleAvatar(
                    child: Text(getNameInitials(name) ?? ''),
                  ),
                  title: Text(
                    name,
                    semanticsLabel: '$name, ${_status(l10n, reply)}',
                  ),
                  trailing: ReplyButtons(reply: reply, defaultReply: usual),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A new group's admin: what's left before the group's headcounts mean
/// anything. Each step is done when the group's data says so.
class GroupSetup extends StatelessWidget {
  final bool hasEvents;
  final bool hasMembers;
  final VoidCallback? onAddEvent;
  final VoidCallback? onInvite;

  const GroupSetup({
    super.key,
    required this.hasEvents,
    required this.hasMembers,
    this.onAddEvent,
    this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.groupSetupTitle,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.groupSetupBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SetupStep(number: 1, title: l10n.onboardingStepGroup, done: true),
          SetupStep(
            number: 2,
            title: l10n.groupSetupEvent,
            subtitle: l10n.onboardingStepEventHint,
            done: hasEvents,
            onTap: onAddEvent,
          ),
          SetupStep(
            number: 3,
            title: l10n.onboardingStepInvite,
            subtitle: l10n.onboardingStepInviteHint,
            done: hasMembers,
            onTap: onInvite,
          ),
        ],
      ),
    );
  }
}

/// One step towards a working group: numbered until it's done, then ticked.
class SetupStep extends StatelessWidget {
  final int number;
  final String title;
  final String? subtitle;
  final bool done;

  /// Takes the user to the step. Ignored once it's done.
  final VoidCallback? onTap;

  const SetupStep({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
    this.done = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final subtitle = this.subtitle;
    final onTap = done ? null : this.onTap;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: done
          ? CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: const Icon(Icons.check, size: 18),
            )
          : Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                shape: CircleBorder(
                  side: BorderSide(color: colorScheme.outline),
                ),
              ),
              child: Text(
                '$number',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
      title: Text(
        title,
        style: done ? TextStyle(color: colorScheme.onSurfaceVariant) : null,
      ),
      subtitle: subtitle != null && !done ? Text(subtitle) : null,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
