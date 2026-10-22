import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the last data a repository loaded, so the app has something to show
/// before the network answers, or without a network at all.
///
/// Each entry records its owner and format version: data saved by another
/// user, by an incompatible app version, or that no longer decodes is
/// dropped rather than trusted.
class LocalCache {
  LocalCache(this._prefs);

  /// Opens the cache with every entry read into memory, so that [read] is
  /// synchronous: a repository swaps in a user's data in one step, with no
  /// window for a network response to land first and be overwritten.
  static Future<LocalCache> open(Set<String> keys) async => LocalCache(
    await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(allowList: keys),
    ),
  );

  final SharedPreferencesWithCache _prefs;

  /// Bump whenever a cached model's JSON shape changes incompatibly.
  static const version = 1;

  /// The data [userId] saved under [key], or `null` if there is none usable.
  Map<String, dynamic>? read(String key, {required String userId}) {
    try {
      final raw = _prefs.getString(key);
      if (raw == null) return null;
      final entry = jsonDecode(raw) as Map<String, dynamic>;
      if (entry['version'] != version || entry['userId'] != userId) {
        return null;
      }
      return entry['data'] as Map<String, dynamic>;
    } catch (_) {
      return null; // Unreadable: start empty.
    }
  }

  Future<void> write(
    String key, {
    required String userId,
    required Map<String, dynamic> data,
  }) => _prefs.setString(
    key,
    jsonEncode({'version': version, 'userId': userId, 'data': data}),
  );

  Future<void> remove(String key) => _prefs.remove(key);
}
