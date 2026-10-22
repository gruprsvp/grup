import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parousia/go_router_builder.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:styled_text/styled_text.dart';

class HomeScreen extends StatelessWidget {
  final Profile? profile;
  final Iterable<Group>? groups;
  final bool loading;

  /// Why the groups couldn't be loaded, if they couldn't.
  final Exception? error;
  final ValueSetter<GroupCreateResult>? onGroupCreate;
  final AsyncCallback? onRefresh;
  final bool? shouldShowFeedback;
  final VoidCallback? onFeedbackDismiss;

  const HomeScreen({
    super.key,
    this.loading = false,
    this.profile,
    this.groups,
    this.error,
    this.onGroupCreate,
    this.onRefresh,
    this.shouldShowFeedback,
    this.onFeedbackDismiss,
  });

  ImageProvider? _profilePicture() {
    if (profile?.picture != null) {
      return NetworkImage(profile!.picture!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final nothingToShow = groups == null || groups!.isEmpty;
    final error = this.error;
    final innerBody = nothingToShow && error != null
        // Not "no groups yet": we couldn't tell.
        ? _Scrollable(
            child: ErrorNotice(error: error, onRetry: onRefresh),
          )
        : nothingToShow
        ? _Scrollable(
            child: EmptyState(
              image: 'home.webp',
              text: StyledText(
                text: l10n.onboardingMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
                tags: {
                  'title': StyledTextTag(
                    style: GoogleFonts.sniglet(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  'plus': StyledTextWidgetTag(
                    TextButton.icon(
                      icon: Icon(Icons.group_add_outlined),
                      label: Text(l10n.createOrJoinGroup),
                      onPressed: () => _onGroupCreate(context),
                    ),
                  ),
                },
              ),
            ),
          )
        : GroupsList(groups: groups);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            title: Text(
              l10n.appName,
              style: GoogleFonts.sniglet(
                color: theme.colorScheme.primary,
                textStyle: theme.textTheme.headlineLarge,
              ),
            ),
            bottom: loading
                ? PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width, 0),
                    child: const LinearProgressIndicator(),
                  )
                : null,
            actions: [
              ProfilePicture(
                onPressed: () =>
                    const ProfileRoute(userNavigated: true).push(context),
                image: _profilePicture(),
                name: profile?.displayName,
                icon: Icons.person,
              ),
            ],
          ),
          if (error != null && !nothingToShow)
            SliverToBoxAdapter(
              child: ErrorNotice(error: error, onRetry: onRefresh),
            ),
          if (shouldShowFeedback == true)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Dismissible(
                  key: ValueKey('feedbackCard'),
                  child: const FeedbackCard(),
                  onDismissed: (_) => onFeedbackDismiss?.call(),
                ),
              ),
            ),
        ],
        body: RefreshIndicator(
          onRefresh: () async => onRefresh?.call(),
          child: innerBody,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onGroupCreate(context),
        label: Text(l10n.createOrJoinGroup),
        icon: const Icon(Icons.group_add_outlined),
      ),
    );
  }

  Future<void> _onGroupCreate(BuildContext context) {
    return const GroupCreateRoute()
        .push<GroupCreateResult>(context)
        .then((value) => value != null ? onGroupCreate?.call(value) : null);
  }
}

/// Fills the viewport and scrolls, so pull-to-refresh works on it.
class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [SliverFillRemaining(hasScrollBody: false, child: child)],
  );
}
