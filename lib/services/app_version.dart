import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// The oldest app version each platform still supports, published with the
/// web app (`web/app_version.json`), so it can be raised without a release.
class AppVersionService {
  AppVersionService({http.Client? client}) : _client = client ?? http.Client();

  static final _url = Uri.parse('https://grup.rsvp/app_version.json');

  final http.Client _client;

  /// Whether [version] is older than the minimum for [platform] (`android`,
  /// `ios`).
  ///
  /// Unlike the other services this never throws: anything but a readable
  /// minimum lets the app run. The host answers a missing file with
  /// index.html, so a bad deploy can't lock everyone out.
  Future<bool> updateRequired({
    required String version,
    required String platform,
  }) async {
    try {
      final response = await _client
          .get(_url)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return false;
      final minimum = (jsonDecode(response.body) as Map)[platform];
      return minimum is String && isOlderVersion(version, minimum);
    } catch (_) {
      return false;
    }
  }
}

/// Compares dotted versions (`2.10.0` > `2.9.1`) number by number; missing
/// numbers count as 0. `false` if either isn't numeric.
bool isOlderVersion(String version, String minimum) {
  final a = version.split('.').map(int.tryParse).toList();
  final b = minimum.split('.').map(int.tryParse).toList();
  if (a.contains(null) || b.contains(null)) return false;
  for (var i = 0; i < a.length || i < b.length; i++) {
    final x = i < a.length ? a[i]! : 0;
    final y = i < b.length ? b[i]! : 0;
    if (x != y) return x < y;
  }
  return false;
}
