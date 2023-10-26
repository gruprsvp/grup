import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/screens/screens.dart';

part 'go_router_builder.g.dart';

@TypedGoRoute<HomeScreenRoute>(
  path: '/',
  routes: [
    TypedGoRoute<SettingsRoute>(
      path: 'settings',
    ),
  ],
)
@immutable
class HomeScreenRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

@immutable
class SettingsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}
