import 'package:flutter/widgets.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Whether [initPostHog] ran: until then (debug and test runs) nothing is sent.
bool _started = false;

/// Whether the user said yes (see [setAnalyticsEnabled]).
bool _enabled = false;

/// The signed-in user, and the one PostHog was last told about.
String? _userId;
String? _sentUserId;

/// The Supabase host this build talks to: tells self-hosted builds apart.
String _backend = '';

/// Initialize PostHog, sending only if the user said yes ([enabled]).
Future<void> initPostHog({
  required String backend,
  required bool enabled,
}) async {
  final config = PostHogConfig(
    'phc_maDGNEUn4Xpo0Nys1jNI2GnZjEQTVD2IIymbcRxBPta',
  );
  config.host = 'https://eu.i.posthog.com';
  config.sendFeatureFlagEvent = false;
  config.preloadFeatureFlags = false;
  // Silent until the choice below: the SDK may remember an older one.
  config.optOut = true;
  await Posthog().setup(config);
  _backend = backend;
  _started = true;
  _enabled = !enabled;
  await setAnalyticsEnabled(enabled);
}

/// Starts or stops sending, as the user chose in the app.
Future<void> setAnalyticsEnabled(bool enabled) async {
  if (!_started || enabled == _enabled) return;
  _enabled = enabled;
  if (!enabled) return Posthog().optOut();
  await Posthog().optIn();
  await Posthog().register('backend', _backend);
  _sync();
}

/// Ties what follows to [userId] (the Supabase user id, nothing personal), or
/// starts over anonymously after a sign-out.
void identify(String? userId) {
  _userId = userId;
  _sync();
}

void _sync() {
  if (!_started || !_enabled || _userId == _sentUserId) return;
  _sentUserId = _userId;
  // Analytics failing must never fail what the user is doing.
  (_userId == null
          // A reset also forgets registered properties.
          ? Posthog().reset().then(
              (_) => Posthog().register('backend', _backend),
            )
          : Posthog().identify(userId: _userId!))
      .ignore();
}

/// Records that the user did [event] (`object verb`, e.g. `group created`).
void track(String event, [Map<String, Object>? properties]) {
  if (_started && _enabled) {
    Posthog().capture(eventName: event, properties: properties).ignore();
  }
}

/// Records a screen view per route pattern (e.g. `groups/:groupId`). PostHog
/// drops them while the user hasn't said yes.
List<NavigatorObserver> get analyticsObservers => [
  if (_started) PosthogObserver(),
];

/// Initialize Sentry
Future<void> initSentry(AppRunner appRunner, {required String backend}) async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://377e317b8978ea82dfbc3980ba960339@o4508580592484352.ingest.de.sentry.io/4508580610572368';
      options.tracesSampleRate = 0.5;
    },
    appRunner: () async {
      await Sentry.configureScope((scope) => scope.setTag('backend', backend));
      return appRunner();
    },
  );
}
