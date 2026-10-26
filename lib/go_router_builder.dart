import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:provider/provider.dart';

part 'go_router_builder.g.dart';

// Every route but /auth needs a signed-in user; the redirect in router.dart
// enforces that for all of them.
//
// Open a page with `go` when its parent route is the page on screen: the
// stack stays the same and the web address follows, so a refresh or a shared
// link reopens it. `push` (address unchanged) is for pages that return a
// result or whose parent route isn't the page on screen.
@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<JoinRoute>(path: 'join/:code'),
    TypedGoRoute<ProfileRoute>(path: 'profile'),
    TypedGoRoute<SelectContactsRoute>(path: 'contacts-select'),
    TypedGoRoute<GroupCreateRoute>(path: 'group-create'),
    TypedGoRoute<GroupDetailsRoute>(
      path: 'groups/:groupId',
      routes: [
        TypedGoRoute<GroupManageRoute>(path: 'manage'),
        TypedGoRoute<GroupScheduleCreateRoute>(path: 'schedule-create'),
        TypedGoRoute<GroupScheduleDetailsRoute>(path: 'schedules/:scheduleId'),
        TypedGoRoute<GroupMemberDetailsRoute>(path: 'members/:memberId'),
        TypedGoRoute<GroupPlanRoute>(path: 'plan'),
        TypedGoRoute<GroupKitchenRoute>(path: 'kitchen'),
      ],
    ),
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [
        TypedGoRoute<LocaleRoute>(path: 'locale'),
        TypedGoRoute<SettingsMoreRoute>(path: 'more'),
        TypedGoRoute<LicensesRoute>(path: 'licenses'),
      ],
    ),
  ],
)
@immutable
class HomeScreenRoute extends GoRouteData with $HomeScreenRoute {
  const HomeScreenRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: HomeContainer());
}

// Top level, so the signed-out user's stack is this page alone (as a child
// of '/', the home page would be built underneath it).
@TypedGoRoute<AuthRoute>(path: '/auth')
@immutable
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute({this.from});

  /// Where to go once signed in.
  final String? from;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: AuthScreen());
}

/// An invite link: https://grup.rsvp/join/CODE.
@immutable
class JoinRoute extends GoRouteData with $JoinRoute {
  const JoinRoute({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ReadableWidth(child: JoinGroupContainer(code: code));
}

@immutable
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: SettingsContainer());
}

@immutable
class LocaleRoute extends GoRouteData with $LocaleRoute {
  const LocaleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: LocaleContainer());
}

@immutable
class SettingsMoreRoute extends GoRouteData with $SettingsMoreRoute {
  const SettingsMoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: SettingsMoreContainer());
}

@immutable
class LicensesRoute extends GoRouteData with $LicensesRoute {
  const LicensesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: LicensePage());
}

@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute({this.userNavigated});

  /// Opened by the user, rather than to ask a new user for their name.
  final bool? userNavigated;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ReadableWidth(child: ProfileContainer(userNavigated: userNavigated));
}

@immutable
class GroupCreateRoute extends GoRouteData with $GroupCreateRoute {
  const GroupCreateRoute({this.create});

  /// Opens on creating a group rather than joining one.
  final bool? create;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ReadableWidth(child: GroupCreateScreen(create: create ?? false));
}

@immutable
class GroupDetailsRoute extends GoRouteData with $GroupDetailsRoute {
  const GroupDetailsRoute({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      // Keyed, so another group's address gets its own view model.
      GroupDetailsContainer(key: ValueKey(groupId), groupId: groupId);
}

@immutable
class GroupManageRoute extends GoRouteData with $GroupManageRoute {
  const GroupManageRoute({required this.groupId});

  final String groupId;

  /// Only admins manage a group. Until the group has loaded, let the page
  /// open: row-level security refuses non-admins' changes anyway.
  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final member = context.read<GroupsRepository>().ownMember(groupId);
    return member == null || member.role == GroupRoles.admin
        ? null
        : GroupDetailsRoute(groupId: groupId).location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ReadableWidth(child: GroupManageContainer(groupId: groupId));
}

@immutable
class GroupScheduleCreateRoute extends GoRouteData
    with $GroupScheduleCreateRoute {
  const GroupScheduleCreateRoute({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ReadableWidth(
    child: ScheduleCreateScreen(
      showCutoff: context
          .read<BillingRepository>()
          .access(groupId)
          .show(FeatureKey.replyCutoffs),
    ),
  );
}

/// One occurrence of a schedule, at [at].
@immutable
class GroupScheduleDetailsRoute extends GoRouteData
    with $GroupScheduleDetailsRoute {
  const GroupScheduleDetailsRoute({
    required this.groupId,
    required this.scheduleId,
    required this.at,
  });

  final String groupId;
  final String scheduleId;
  final DateTime at;

  /// On a wide window, the event opens next to the group's day.
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TwoPane.isWide(context)
      // Keyed: the page is updated in place when the address changes, so a
      // link to another group or event must not keep the old view model.
      ? GroupDetailsContainer(
          key: ValueKey(groupId),
          groupId: groupId,
          selected: (scheduleId: scheduleId, at: at),
        )
      : ReadableWidth(
          child: GroupScheduleDetailsContainer(
            key: ValueKey((scheduleId, at)),
            groupId: groupId,
            scheduleId: scheduleId,
            instanceDate: at,
          ),
        );

  /// One page class at every width, under go_router's key (the route's
  /// pattern): opening another event, or resizing, updates the page in place
  /// instead of pushing a new one.
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => PanesPage(
    key: state.pageKey,
    name: state.name ?? state.path,
    arguments: state.pathParameters,
    restorationId: state.pageKey.value,
    child: build(context, state),
  );
}

@immutable
class GroupMemberDetailsRoute extends GoRouteData
    with $GroupMemberDetailsRoute {
  const GroupMemberDetailsRoute({
    required this.groupId,
    required this.memberId,
  });

  final String groupId;
  final String memberId;

  @override
  Widget build(BuildContext context, GoRouterState state) => ReadableWidth(
    child: GroupMemberDetailsContainer(groupId: groupId, memberId: memberId),
  );
}

/// A group's plan: what it may do and why, and buying or managing one.
/// Admins only, and on the web only: the apps sell nothing yet.
@immutable
class GroupPlanRoute extends GoRouteData with $GroupPlanRoute {
  const GroupPlanRoute({required this.groupId, this.checkout});

  final String groupId;

  /// `success` when Stripe Checkout sends the admin back after paying.
  final String? checkout;

  /// Until the group has loaded, let the page open: the server refuses
  /// non-admins' checkouts anyway.
  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final member = context.read<GroupsRepository>().ownMember(groupId);
    final isAdmin = member == null || member.role == GroupRoles.admin;
    return appPlatform == null && isAdmin
        ? null
        : GroupDetailsRoute(groupId: groupId).location;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) => ReadableWidth(
    child: GroupPlanContainer(
      groupId: groupId,
      checkoutSuccess: checkout == 'success',
    ),
  );
}

/// A day of a group's events as the kitchen needs it (kitchen_view).
@immutable
class GroupKitchenRoute extends GoRouteData with $GroupKitchenRoute {
  const GroupKitchenRoute({required this.groupId, this.date});

  final String groupId;

  /// The day, as YYYY-MM-DD; today without one.
  final String? date;

  @override
  Widget build(BuildContext context, GoRouterState state) => ReadableWidth(
    child: GroupKitchenContainer(
      groupId: groupId,
      date: DateTime.tryParse(date ?? ''),
    ),
  );
}

@immutable
class SelectContactsRoute extends GoRouteData with $SelectContactsRoute {
  const SelectContactsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ReadableWidth(child: SelectContactsScreen());
}

/// A [MaterialPage] with no transition on wide windows, where the event it
/// opens appears next to the list already on screen.
class PanesPage<T> extends MaterialPage<T> {
  const PanesPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => _PanesRoute<T>(this);
}

class _PanesRoute<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  _PanesRoute(PanesPage<T> page) : super(settings: page);

  bool get _wide => TwoPane.isWide(navigator!.context);

  @override
  Widget buildContent(BuildContext context) => (settings as PanesPage<T>).child;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      _wide ? Duration.zero : super.transitionDuration;

  @override
  Duration get reverseTransitionDuration =>
      _wide ? Duration.zero : super.reverseTransitionDuration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => _wide
      ? child
      : super.buildTransitions(context, animation, secondaryAnimation, child);
}
