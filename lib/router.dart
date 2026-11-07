import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:parousia/presentation/presentation.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/analytics.dart';

import 'go_router_builder.dart';

/// The app's routes. Re-runs [redirect] whenever the signed-in user changes,
/// and when billing's state (which holds the terms) does.
GoRouter createRouter(AuthRepository auth, BillingRepository billing) =>
    GoRouter(
      routes: $appRoutes,
      observers: analyticsObservers,
      refreshListenable: Listenable.merge([auth, billing]),
      redirect: (context, state) => redirect(
        state.uri,
        auth.isAuthenticated,
        termsPending: billing.state.termsPending,
      ),
      errorBuilder: (context, state) =>
          NotFoundScreen(onHome: () => const HomeScreenRoute().go(context)),
    );

/// Where to send a user who asked for [uri], or `null` to let them in.
/// While [termsPending], a signed-in user sees only the terms.
String? redirect(Uri uri, bool isAuthenticated, {bool termsPending = false}) {
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

  // Cancelling and withdrawing need no account and come before the terms
  // (§ 312k and § 356a BGB): never redirected.
  if (uri.path == const CancelRoute().location) return null;

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
  final terms = const TermsRoute().location;
  if (termsPending && uri.path != terms) {
    final from = uri.toString();
    return TermsRoute(from: from == '/' ? null : from).location;
  }
  if (!termsPending && uri.path == terms) {
    final from = uri.queryParameters['from'];
    return _isLocal(from) ? from : const HomeScreenRoute().location;
  }
  return null;
}

/// Only paths in this app: an absolute or protocol-relative URL would make
/// the redirect an open one.
bool _isLocal(String? path) =>
    path != null && path.startsWith('/') && !path.startsWith('//');
