import 'package:parousia/repositories/groups.dart';
import 'package:parousia/repositories/profile.dart';
import 'package:parousia/repositories/schedules.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

/// Points SharedPreferencesAsync (and SharedPreferencesWithCache) at a fresh
/// in-memory store. Call it before creating anything that reads preferences.
void useInMemoryPreferences() {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
}

/// The repositories' cache, on the in-memory store. Opening it again after a
/// save simulates an app restart.
Future<LocalCache> openCache() => LocalCache.open({
  GroupsRepository.cacheKey,
  SchedulesRepository.cacheKey,
  ProfileRepository.cacheKey,
});
