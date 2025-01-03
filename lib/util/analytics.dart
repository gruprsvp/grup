import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Initialize PostHog
Future<void> initPostHog() async {
  final config =
      PostHogConfig('phc_maDGNEUn4Xpo0Nys1jNI2GnZjEQTVD2IIymbcRxBPta');
  config.host = 'https://eu.i.posthog.com';
  config.sendFeatureFlagEvents = false;
  config.preloadFeatureFlags = false;
  final posthog = Posthog();
  await posthog.setup(config);
}

/// Initialize Sentry
Future<void> initSentry(AppRunner? appRunner) async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://377e317b8978ea82dfbc3980ba960339@o4508580592484352.ingest.de.sentry.io/4508580610572368';
      options.tracesSampleRate = 0.5;
      options.profilesSampleRate = 0.5;
    },
    appRunner: appRunner,
  );
}
