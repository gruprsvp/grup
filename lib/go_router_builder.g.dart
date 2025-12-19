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
      factory: $HomeScreenRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'auth',
          factory: $AuthRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'profile',
          factory: $ProfileRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'contacts-select',
          factory: $SelectContactsRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'group-create',
          factory: $GroupCreateRoute._fromState,
        ),
        GoRouteData.$route(
          path: 'groups/:groupId',
          factory: $GroupDetailsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'manage',
              factory: $GroupManageRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'schedule-create',
              factory: $GroupScheduleCreateRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'schedules/:scheduleId',
              factory: $GroupScheduleDetailsRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'members/:memberId',
              factory: $GroupMemberDetailsRoute._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'settings',
          factory: $SettingsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'locale',
              factory: $LocaleRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'more',
              factory: $SettingsMoreRoute._fromState,
            ),
            GoRouteData.$route(
              path: 'licenses',
              factory: $LicensesRoute._fromState,
            ),
          ],
        ),
      ],
    );

mixin $HomeScreenRoute on GoRouteData {
  static HomeScreenRoute _fromState(GoRouterState state) => HomeScreenRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => AuthRoute();

  @override
  String get location => GoRouteData.$location(
        '/auth',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => ProfileRoute(
        userNavigated: _$convertMapValue(
            'user-navigated', state.uri.queryParameters, _$boolConverter),
      );

  ProfileRoute get _self => this as ProfileRoute;

  @override
  String get location => GoRouteData.$location(
        '/profile',
        queryParams: {
          if (_self.userNavigated != null)
            'user-navigated': _self.userNavigated!.toString(),
        },
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SelectContactsRoute on GoRouteData {
  static SelectContactsRoute _fromState(GoRouterState state) =>
      SelectContactsRoute();

  @override
  String get location => GoRouteData.$location(
        '/contacts-select',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupCreateRoute on GoRouteData {
  static GroupCreateRoute _fromState(GoRouterState state) => GroupCreateRoute();

  @override
  String get location => GoRouteData.$location(
        '/group-create',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupDetailsRoute on GoRouteData {
  static GroupDetailsRoute _fromState(GoRouterState state) => GroupDetailsRoute(
        groupId: state.pathParameters['groupId']!,
      );

  GroupDetailsRoute get _self => this as GroupDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(_self.groupId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupManageRoute on GoRouteData {
  static GroupManageRoute _fromState(GoRouterState state) => GroupManageRoute(
        groupId: state.pathParameters['groupId']!,
      );

  GroupManageRoute get _self => this as GroupManageRoute;

  @override
  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(_self.groupId)}/manage',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupScheduleCreateRoute on GoRouteData {
  static GroupScheduleCreateRoute _fromState(GoRouterState state) =>
      GroupScheduleCreateRoute(
        groupId: state.pathParameters['groupId']!,
      );

  GroupScheduleCreateRoute get _self => this as GroupScheduleCreateRoute;

  @override
  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(_self.groupId)}/schedule-create',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupScheduleDetailsRoute on GoRouteData {
  static GroupScheduleDetailsRoute _fromState(GoRouterState state) =>
      GroupScheduleDetailsRoute(
        groupId: state.pathParameters['groupId']!,
        scheduleId: state.pathParameters['scheduleId']!,
      );

  GroupScheduleDetailsRoute get _self => this as GroupScheduleDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(_self.groupId)}/schedules/${Uri.encodeComponent(_self.scheduleId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GroupMemberDetailsRoute on GoRouteData {
  static GroupMemberDetailsRoute _fromState(GoRouterState state) =>
      GroupMemberDetailsRoute(
        groupId: state.pathParameters['groupId']!,
        memberId: state.pathParameters['memberId']!,
      );

  GroupMemberDetailsRoute get _self => this as GroupMemberDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/groups/${Uri.encodeComponent(_self.groupId)}/members/${Uri.encodeComponent(_self.memberId)}',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LocaleRoute on GoRouteData {
  static LocaleRoute _fromState(GoRouterState state) => LocaleRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/locale',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsMoreRoute on GoRouteData {
  static SettingsMoreRoute _fromState(GoRouterState state) =>
      SettingsMoreRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/more',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $LicensesRoute on GoRouteData {
  static LicensesRoute _fromState(GoRouterState state) => LicensesRoute();

  @override
  String get location => GoRouteData.$location(
        '/settings/licenses',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
