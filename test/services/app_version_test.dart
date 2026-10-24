import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:parousia/services/services.dart';

void main() {
  test('compares versions number by number', () {
    expect(isOlderVersion('2.0.0', '2.0.1'), isTrue);
    expect(isOlderVersion('2.9.0', '2.10.0'), isTrue);
    expect(isOlderVersion('2.10.0', '2.9.0'), isFalse);
    expect(isOlderVersion('2.0.0', '2.0.0'), isFalse);
    expect(isOlderVersion('2.0', '2.0.1'), isTrue);
    expect(isOlderVersion('2.0.0', 'garbage'), isFalse);
  });

  Future<bool> updateRequired(http.Response response) =>
      AppVersionService(client: MockClient((_) async => response))
          .updateRequired(version: '2.0.0', platform: 'ios');

  test('reads the minimum for the platform', () async {
    const body = '{"android": "2.0.0", "ios": "2.1.0"}';
    expect(await updateRequired(http.Response(body, 200)), isTrue);
  });

  test('lets the app run when the minimum cannot be read', () async {
    // The host answers a missing file with index.html.
    expect(
      await updateRequired(http.Response('<!DOCTYPE html>', 200)),
      isFalse,
    );
    expect(await updateRequired(http.Response('{"ios": 3}', 200)), isFalse);
    expect(await updateRequired(http.Response('{"ios": "9"}', 500)), isFalse);
    expect(
      await AppVersionService(
        client: MockClient((_) => throw http.ClientException('offline')),
      ).updateRequired(version: '2.0.0', platform: 'ios'),
      isFalse,
    );
  });
}
