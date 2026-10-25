import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/util/analytics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sends only once started and the user said yes', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('posthog_flutter'), (
          call,
        ) async {
          calls.add(call.method);
          return null;
        });
    Future<List<String>> sent() async {
      await pumpEventQueue();
      final sent = [...calls];
      calls.clear();
      return sent;
    }

    // Debug and test runs: never started.
    identify('a');
    track('group created');
    expect(analyticsObservers, isEmpty);
    expect(await sent(), isEmpty);

    // Started, but the user hasn't said yes.
    await initPostHog(backend: 'grup.supabase.co', enabled: false);
    expect(await sent(), ['setup', 'disable']);
    track('group created');
    expect(await sent(), isEmpty);

    // Saying yes catches up on who is signed in.
    await setAnalyticsEnabled(true);
    expect(await sent(), ['enable', 'register', 'identify']);
    identify('a');
    expect(await sent(), isEmpty);

    track('group created', {'group_id': 'g'});
    expect(await sent(), ['capture']);

    identify(null);
    expect(await sent(), ['reset', 'register']);

    await setAnalyticsEnabled(false);
    track('group created');
    expect(await sent(), ['disable']);
  });
}
