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
          'https://1b0aa021dcaeef223fe5ee6105969fe4@o4508562988597248.ingest.de.sentry.io/4508562990039120';
      options.tracesSampleRate = 0.5;
      options.profilesSampleRate = 0.5;
    },
    appRunner: appRunner,
  );
}
