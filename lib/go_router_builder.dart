import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/containers/containers.dart';
import 'package:parousia/containers/home_page.dart';
import 'package:parousia/screens/screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'go_router_builder.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<AuthRoute>(path: 'auth'),
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
      routes: [
        TypedGoRoute<LocaleRoute>(path: 'locale'),
      ],
    ),
    TypedGoRoute<ProfileRoute>(path: 'profile'),
    TypedGoRoute<NewGroupRoute>(path: 'new-group'),
    TypedGoRoute<GroupDetailsRoute>(
      path: 'groups/:groupId',
      routes: [
        TypedGoRoute<GroupManageRoute>(path: 'manage'),
      ],
    )
  ],
)
@immutable
class HomeScreenRoute extends GoRouteData with AuthenticationGuard {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

@immutable
class AuthRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthScreen();
}

@immutable
class SettingsRoute extends GoRouteData with AuthenticationGuard {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

@immutable
class LocaleRoute extends GoRouteData with AuthenticationGuard {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocaleSelector();
}

@immutable
class ProfileRoute extends GoRouteData with AuthenticationGuard {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
}

@immutable
class NewGroupRoute extends GoRouteData with AuthenticationGuard {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NewGroupScreen();
}

@immutable
class GroupDetailsRoute extends GoRouteData with AuthenticationGuard {
  final String groupId;

  const GroupDetailsRoute({required this.groupId});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      GroupDetails(groupId: groupId);
}

@immutable
class GroupManageRoute extends GoRouteData with AuthenticationGuard {
  final String groupId;

  const GroupManageRoute({required this.groupId});

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ManageGroup(groupId: groupId);
}

// Check if a user exists in the Supabase client
_isAuthenticated() => Supabase.instance.client.auth.currentUser != null;

/// Routes that require authentication should use this mixin
mixin AuthenticationGuard on GoRouteData {
  @override
  redirect(BuildContext context, GoRouterState state) =>
      _isAuthenticated() ? null : AuthRoute().location;
// TODO(borgoat): This redirect keeps the previous route in the stack,
//                It should replace the current route, to prevent the user
//                from navigating back to the home page while signed out.
//                Investigate whether to use a "splashscreen" route instead.
}
