import 'package:go_router/go_router.dart';

import 'go_router_builder.dart';

final router = GoRouter(
  routes: $appRoutes,
  redirect: (context, state) {
    return state.uri.scheme.isNotEmpty ? HomeScreenRoute().location : null;
  },
);
