import 'package:go_router/go_router.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/analytics.dart';

import 'go_router_builder.dart';

/// The app's routes. Re-runs [redirect] whenever the signed-in user changes.
GoRouter createRouter(AuthRepository auth) => GoRouter(
  routes: $appRoutes,
  observers: analyticsObservers,
  refreshListenable: auth,
  redirect: (context, state) => redirect(state.uri, auth.isAuthenticated),
  errorBuilder: (context, state) =>
      NotFoundScreen(onHome: () => const HomeScreenRoute().go(context)),
);

/// Where to send a user who asked for [uri], or `null` to let them in.
String? redirect(Uri uri, bool isAuthenticated) {
  // A link that opened the app (Flutter's deep linking) arrives with its
  // scheme and host. Open https://grup.rsvp/... links at their path; any
  // other scheme (grup://auth-callback, whose sign-in code Supabase
  // handles) goes home.
  if (uri.hasScheme) {
    if (!uri.isScheme('https') && !uri.isScheme('http')) {
      return const HomeScreenRoute().location;
    }
    return Uri(
      path: uri.path.isEmpty ? '/' : uri.path,
      query: uri.hasQuery ? uri.query : null,
    ).toString();
  }

  final auth = const AuthRoute().location;
  if (!isAuthenticated) {
    if (uri.path == auth) return null;
    // Come back here after signing in (e.g. to an invite link).
    final from = uri.toString();
    return AuthRoute(from: from == '/' ? null : from).location;
  }
  if (uri.path == auth) {
    final from = uri.queryParameters['from'];
    return _isLocal(from) ? from : const HomeScreenRoute().location;
  }
  // Back from a page outside the app (Stripe): the web host answers only
  // the root, so the page to return to comes as ?return=.
  final back = uri.queryParameters['return'];
  if (uri.path == '/' && back != null) {
    return _isLocal(back) ? back : const HomeScreenRoute().location;
  }
  return null;
}

/// Only paths in this app: an absolute or protocol-relative URL would make
/// the redirect an open one.
bool _isLocal(String? path) =>
    path != null && path.startsWith('/') && !path.startsWith('//');
