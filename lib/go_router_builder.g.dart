// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_router_builder.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeScreenRoute,
    ];

RouteBase get $homeScreenRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeScreenRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'auth',
          factory: $AuthRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'profile',
          factory: $ProfileRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'select-contacts',
          factory: $SelectContactsRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'group-create',
          factory: $GroupCreateRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'groups/:groupId',
          factory: $GroupDetailsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'manage',
              factory: $GroupManageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'schedule-create',
              factory: $GroupScheduleCreateRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'schedules/:scheduleId',
              factory: $GroupScheduleDetailsRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'locale',
              factory: $LocaleRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomeScreenRouteExtension on HomeScreenRoute {
  static HomeScreenRoute _fromState(GoRouterState state) => HomeScreenRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AuthRouteExtension on AuthRoute {
  static AuthRoute _fromState(GoRouterState state) => AuthRoute();

  String get location => GoRouteData.$location(
        '/auth',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SelectContactsRouteExtension on SelectContactsRoute {
  static SelectContactsRoute _fromState(GoRouterState state) =>
      SelectContactsRoute();

  String get location => GoRouteData.$location(
        '/select-contacts',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupCreateRouteExtension on GroupCreateRoute {
  static GroupCreateRoute _fromState(GoRouterState state) => GroupCreateRoute();

  String get location => GoRouteData.$location(
        '/group-create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupDetailsRouteExtension on GroupDetailsRoute {
  static GroupDetailsRoute _fromState(GoRouterState state) => GroupDetailsRoute(
        groupId: state.pathParameters['groupId']!,
      );

  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(groupId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupManageRouteExtension on GroupManageRoute {
  static GroupManageRoute _fromState(GoRouterState state) => GroupManageRoute(
        groupId: state.pathParameters['groupId']!,
      );

  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(groupId)}/manage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupScheduleCreateRouteExtension on GroupScheduleCreateRoute {
  static GroupScheduleCreateRoute _fromState(GoRouterState state) =>
      GroupScheduleCreateRoute(
        groupId: state.pathParameters['groupId']!,
      );

  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(groupId)}/schedule-create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $GroupScheduleDetailsRouteExtension on GroupScheduleDetailsRoute {
  static GroupScheduleDetailsRoute _fromState(GoRouterState state) =>
      GroupScheduleDetailsRoute(
        groupId: state.pathParameters['groupId']!,
        scheduleId: state.pathParameters['scheduleId']!,
      );

  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(groupId)}/schedules/${Uri.encodeComponent(scheduleId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LocaleRouteExtension on LocaleRoute {
  static LocaleRoute _fromState(GoRouterState state) => LocaleRoute();

  String get location => GoRouteData.$location(
        '/settings/locale',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
