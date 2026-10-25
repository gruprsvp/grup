import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/util/analytics.dart';
import 'package:parousia/util/errors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Preferences that belong to the device, not to the signed-in user: they
/// survive signing out.
class SettingsRepository extends ChangeNotifier {
  SettingsRepository(this._prefs);

  /// Opens the preferences, importing [legacyState] (see [takeLegacyState])
  /// for any that were never set.
  static Future<SettingsRepository> load({String? legacyState}) async {
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(allowList: _keys),
    );
    final settings = SettingsRepository(prefs);
    if (legacyState != null) settings._import(legacyState);
    return settings;
  }

  static const _themeModeKey = 'themeMode';
  static const _languageKey = 'language';
  static const _feedbackDismissedKey = 'feedbackDismissed';
  static const _analyticsKey = 'analytics';
  static const _keys = {
    _themeModeKey,
    _languageKey,
    _feedbackDismissedKey,
    _analyticsKey,
  };

  final SharedPreferencesWithCache _prefs;

  ThemeMode get themeMode =>
      ThemeMode.values.asNameMap()[_prefs.getString(_themeModeKey)] ??
      ThemeMode.system;

  /// The language the user picked, or `null` to follow the system.
  Locale? get locale => switch (_prefs.getString(_languageKey)) {
    final languageCode? => Locale(languageCode),
    null => null,
  };

  bool get feedbackDismissed => _prefs.getBool(_feedbackDismissedKey) ?? false;

  /// Whether the user shares usage analytics, or `null` until they choose.
  bool? get analytics => _prefs.getBool(_analyticsKey);

  /// Cycles through system → light → dark.
  void nextThemeMode() {
    final next =
        ThemeMode.values[(themeMode.index + 1) % ThemeMode.values.length];
    _save(() => _prefs.setString(_themeModeKey, next.name));
  }

  void setLocale(Locale? locale) => _save(
    () => locale == null
        ? _prefs.remove(_languageKey)
        : _prefs.setString(_languageKey, locale.languageCode),
  );

  void setAnalytics(bool enabled) {
    setAnalyticsEnabled(enabled).ignore();
    _save(() => _prefs.setBool(_analyticsKey, enabled));
  }

  void dismissFeedback() =>
      _save(() => _prefs.setBool(_feedbackDismissedKey, true));

  /// [write] updates the in-memory cache synchronously, so listeners see the
  /// new value straight away; a failure to persist only loses it on restart.
  void _save(Future<void> Function() write) {
    unawaited(guard(write));
    notifyListeners();
  }

  void _import(String legacyState) {
    try {
      final state = jsonDecode(legacyState) as Map<String, dynamic>;
      if (state['themeMode'] case final String themeMode
          when _prefs.getString(_themeModeKey) == null) {
        unawaited(guard(() => _prefs.setString(_themeModeKey, themeMode)));
      }
      if (state['locale'] case {'languageCode': final String languageCode}
          when _prefs.getString(_languageKey) == null) {
        unawaited(guard(() => _prefs.setString(_languageKey, languageCode)));
      }
      if (state['hasSeenFeedbackCard'] == true) {
        unawaited(guard(() => _prefs.setBool(_feedbackDismissedKey, true)));
      }
    } catch (_) {
      // Unreadable: the preferences keep their defaults.
    }
  }
}

/// Reads and deletes the state blob the app persisted up to version 1.7 (the
/// Redux store, saved by redux_persist_flutter), returning its JSON.
///
/// Besides the preferences [SettingsRepository] imports, the blob held cached
/// entities, invitees' email addresses and phone numbers, and the serialized
/// auth user: it must not outlive the upgrade.
Future<String?> takeLegacyState() async {
  try {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final state = prefs.getString('app');
      if (state != null) await prefs.remove('app');
      return state;
    }
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/persist_app.json');
    if (!await file.exists()) return null;
    final state = await file.readAsString();
    await file.delete();
    return state;
  } catch (_) {
    return null; // Best effort: at worst the preferences reset to defaults.
  }
}
