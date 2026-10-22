import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/auth.dart';
import 'package:parousia/repositories/groups.dart';
import 'package:parousia/repositories/profile.dart';
import 'package:parousia/repositories/settings.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

import '../support/fake_backend.dart';
import '../support/preferences.dart';

void main() {
  group('AuthRepository', () {
    test('notifies when the user changes, not on other auth events', () {
      final backend = FakeBackend(userId: null);
      final auth = AuthRepository(backend.auth);
      final userIds = <String?>[];
      auth.addListener(() => userIds.add(auth.userId));

      return Future(() async {
        backend.auth.signIn('me');
        backend.auth.emit(AuthChangeEvent.tokenRefreshed);
        backend.auth.emit(AuthChangeEvent.userUpdated);
        backend.auth.signIn(null);
        await pumpEventQueue();

        expect(userIds, ['me', null]);
      });
    });
  });

  group('ProfileRepository', () {
    late FakeBackend backend;
    late ProfileRepository repository;

    setUp(() async {
      backend = FakeBackend();
      backend.addProfile('me', name: 'Old name');
      useInMemoryPreferences();
      repository = ProfileRepository(
        profiles: backend.profilesService,
        storage: backend.storageService,
        cache: await openCache(),
        authChanges: backend.auth.onAuthStateChange,
      );
      repository.switchUser('me');
    });

    test('save returns the profile as the server stored it', () async {
      await repository.load();

      final result = await repository.save(name: 'New name');

      expect((result as Ok<Profile>).value.displayName, 'New name');
      expect(repository.profile?.displayName, 'New name');
    });

    test(
      'reloads when the auth user is updated (Sign in with Apple)',
      () async {
        await repository.load();
        backend.profiles['me'] = const Profile(
          id: 'me',
          displayName: 'Apple name',
        );

        backend.auth.emit(AuthChangeEvent.userUpdated);
        await pumpEventQueue();

        expect(repository.profile?.displayName, 'Apple name');
      },
    );

    test('loading while signed out fails cleanly', () async {
      repository.switchUser(null);

      final result = await repository.load();

      expect((result as Error).error, isA<NotSignedInException>());
    });
  });

  group('SettingsRepository', () {
    setUp(useInMemoryPreferences);

    test('cycles the theme forwards: system, light, dark, system', () async {
      final settings = await SettingsRepository.load();
      final seen = [settings.themeMode];
      for (var i = 0; i < 3; i++) {
        settings.nextThemeMode();
        seen.add(settings.themeMode);
      }

      expect(seen, [
        ThemeMode.system,
        ThemeMode.light,
        ThemeMode.dark,
        ThemeMode.system,
      ]);
    });

    test('remembers the choices across restarts', () async {
      final settings = await SettingsRepository.load();
      settings.nextThemeMode();
      settings.setLocale(const Locale('it'));
      settings.dismissFeedback();
      await pumpEventQueue();

      final restarted = await SettingsRepository.load();
      expect(restarted.themeMode, ThemeMode.light);
      expect(restarted.locale, const Locale('it'));
      expect(restarted.feedbackDismissed, isTrue);
    });

    test('imports the preferences from the old Redux state', () async {
      final legacy = jsonEncode({
        'themeMode': 'dark',
        'locale': {'languageCode': 'de', 'scriptCode': null},
        'hasSeenFeedbackCard': true,
        'groups': <String, dynamic>{},
      });

      final settings = await SettingsRepository.load(legacyState: legacy);

      expect(settings.themeMode, ThemeMode.dark);
      expect(settings.locale, const Locale('de'));
      expect(settings.feedbackDismissed, isTrue);
    });

    test('an unreadable legacy state leaves the defaults', () async {
      final settings = await SettingsRepository.load(legacyState: '{nope');

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.locale, isNull);
    });
  });

  group('LocalCache', () {
    setUp(useInMemoryPreferences);

    Future<Map<String, dynamic>?> readAfterRestart(String userId) async =>
        (await openCache()).read(GroupsRepository.cacheKey, userId: userId);

    Future<void> saveRaw(String value) =>
        SharedPreferencesAsync().setString(GroupsRepository.cacheKey, value);

    test('returns data only to the user who saved it', () async {
      await (await openCache()).write(
        GroupsRepository.cacheKey,
        userId: 'me',
        data: {'a': 1},
      );

      expect(await readAfterRestart('me'), {'a': 1});
      expect(await readAfterRestart('someone else'), isNull);
    });

    test('ignores data saved in another format version', () async {
      await saveRaw(
        jsonEncode({
          'version': LocalCache.version + 1,
          'userId': 'me',
          'data': <String, dynamic>{},
        }),
      );

      expect(await readAfterRestart('me'), isNull);
    });

    test('ignores data that does not decode', () async {
      await saveRaw('not json');

      expect(await readAfterRestart('me'), isNull);
    });
  });
}
