import 'package:posthog_flutter/posthog_flutter.dart';

/// Initialize PostHog
Future<void> initAnalytics() async {
  final config =
      PostHogConfig('phc_maDGNEUn4Xpo0Nys1jNI2GnZjEQTVD2IIymbcRxBPta');
  config.host = 'https://eu.i.posthog.com';
  config.sendFeatureFlagEvents = false;
  config.preloadFeatureFlags = false;
  final posthog = Posthog();
  await posthog.setup(config);
}

/// Identify user in PostHog
Future<void> identifyUser(
    String userId, Map<String, Object>? userProperties) async {
  await Posthog().identify(userId: userId, userProperties: userProperties);
}
