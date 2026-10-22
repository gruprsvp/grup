import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:provider/provider.dart';

part 'go_router_builder.g.dart';

// Every route but /auth needs a signed-in user; the redirect in router.dart
// enforces that for all of them.
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
      const HomeContainer();
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
  Widget build(BuildContext context, GoRouterState state) => const AuthScreen();
}

/// An invite link: https://grup.rsvp/join/CODE.
@immutable
class JoinRoute extends GoRouteData with $JoinRoute {
  const JoinRoute({required this.code});

  final String code;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      JoinGroupContainer(code: code);
}

@immutable
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsContainer();
}

@immutable
class LocaleRoute extends GoRouteData with $LocaleRoute {
  const LocaleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocaleContainer();
}

@immutable
class SettingsMoreRoute extends GoRouteData with $SettingsMoreRoute {
  const SettingsMoreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsMoreContainer();
}

@immutable
class LicensesRoute extends GoRouteData with $LicensesRoute {
  const LicensesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LicensePage();
}

@immutable
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute({this.userNavigated});

  /// Opened by the user, rather than to ask a new user for their name.
  final bool? userNavigated;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProfileContainer(userNavigated: userNavigated);
}

@immutable
class GroupCreateRoute extends GoRouteData with $GroupCreateRoute {
  const GroupCreateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const GroupCreateScreen();
}

@immutable
class GroupDetailsRoute extends GoRouteData with $GroupDetailsRoute {
  const GroupDetailsRoute({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      GroupDetailsContainer(groupId: groupId);
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
      GroupManageContainer(groupId: groupId);
}

@immutable
class GroupScheduleCreateRoute extends GoRouteData
    with $GroupScheduleCreateRoute {
  const GroupScheduleCreateRoute({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ScheduleCreateScreen();
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

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      GroupScheduleDetailsContainer(
        groupId: groupId,
        scheduleId: scheduleId,
        instanceDate: at,
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
  Widget build(BuildContext context, GoRouterState state) =>
      GroupMemberDetailsContainer(groupId: groupId, memberId: memberId);
}

@immutable
class SelectContactsRoute extends GoRouteData with $SelectContactsRoute {
  const SelectContactsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectContactsScreen();
}
