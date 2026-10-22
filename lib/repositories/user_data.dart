import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:parousia/services/local_cache.dart';

/// Base for repositories that hold the signed-in user's data and keep a copy
/// of it on the device.
///
/// [switchUser] swaps the data for another user's. A request that was still
/// running when the user changed must not touch the new user's data: read
/// [generation] before the request, and apply its result with [ifCurrent].
abstract class UserData extends ChangeNotifier {
  UserData(this._cache, this._cacheKey);

  final LocalCache _cache;
  final String _cacheKey;

  String? _userId;
  int _generation = 0;
  bool _saveScheduled = false;

  /// The user whose data this holds, or `null` when signed out.
  String? get userId => _userId;

  /// Empties the in-memory data.
  @protected
  void clear();

  /// The data to keep on the device.
  @protected
  Map<String, dynamic> toCache();

  /// Restores data saved by [toCache]. May throw if it doesn't decode.
  @protected
  void fromCache(Map<String, dynamic> json);

  /// Replaces the current data with [userId]'s copy from the device, or
  /// with nothing when signed out.
  void switchUser(String? userId) {
    if (userId == _userId) return;
    _userId = userId;
    _generation++;
    clear();
    if (userId == null) {
      // Signed out: don't leave their data on a possibly shared device.
      unawaited(_cache.remove(_cacheKey).catchError((Object _) {}));
    } else if (_cache.read(_cacheKey, userId: userId) case final cached?) {
      try {
        fromCache(cached);
      } catch (_) {
        clear(); // Saved by an older model: start empty instead.
      }
    }
    notifyListeners();
  }

  /// Snapshot to pass to [ifCurrent] once a request completes.
  @protected
  int get generation => _generation;

  /// Applies [update], notifies and saves, unless the user changed since
  /// [generation] was read.
  @protected
  void ifCurrent(int generation, VoidCallback update) {
    if (generation != _generation) return;
    update();
    notifyListeners();
    _scheduleSave();
  }

  /// Saves once per event-loop turn, however many updates happened in it.
  void _scheduleSave() {
    if (_saveScheduled) return;
    _saveScheduled = true;
    scheduleMicrotask(() {
      _saveScheduled = false;
      final userId = _userId;
      if (userId == null) return;
      // A failed save only loses the copy on the device.
      unawaited(
        _cache
            .write(_cacheKey, userId: userId, data: toCache())
            .catchError((Object _) {}),
      );
    });
  }
}
