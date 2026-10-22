import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'repositories/repositories.dart';
import 'services/local_cache.dart';
import 'services/services.dart';

/// The services the repositories are built on. Tests swap in fakes.
typedef Services = ({
  GoTrueClient auth,
  GroupsService groups,
  MembersService members,
  InvitesService invites,
  ProfilesService profiles,
  StorageService storage,
  SchedulesService schedules,
  DefaultRulesService defaultRules,
  RepliesService replies,
});

Services supabaseServices(SupabaseClient supabase) => (
  auth: supabase.auth,
  groups: GroupsService(supabase: supabase),
  members: MembersService(supabase: supabase),
  invites: InvitesService(supabase: supabase),
  profiles: ProfilesService(supabase: supabase),
  storage: StorageService(supabase: supabase),
  schedules: SchedulesService(supabase: supabase),
  defaultRules: DefaultRulesService(supabase: supabase),
  replies: RepliesService(supabase: supabase),
);

/// The app's repositories, kept on the signed-in user's data.
class Repositories {
  Repositories._(
    this.auth,
    this.settings,
    this.groups,
    this.schedules,
    this.profile,
  ) {
    _switchUser();
    auth.addListener(_switchUser);
  }

  static Future<Repositories> create(
    Services services, {
    String? legacyState,
  }) async {
    final cache = await LocalCache.open({
      GroupsRepository.cacheKey,
      SchedulesRepository.cacheKey,
      ProfileRepository.cacheKey,
    });
    return Repositories._(
      AuthRepository(services.auth),
      await SettingsRepository.load(legacyState: legacyState),
      GroupsRepository(
        groups: services.groups,
        members: services.members,
        invites: services.invites,
        storage: services.storage,
        cache: cache,
      ),
      SchedulesRepository(
        schedules: services.schedules,
        defaultRules: services.defaultRules,
        replies: services.replies,
        cache: cache,
      ),
      ProfileRepository(
        profiles: services.profiles,
        storage: services.storage,
        cache: cache,
        authChanges: services.auth.onAuthStateChange,
      ),
    );
  }

  final AuthRepository auth;
  final SettingsRepository settings;
  final GroupsRepository groups;
  final SchedulesRepository schedules;
  final ProfileRepository profile;

  /// For [MultiProvider]: view models read the repositories from here.
  List<SingleChildWidget> get providers => [
    ChangeNotifierProvider.value(value: auth),
    ChangeNotifierProvider.value(value: settings),
    ChangeNotifierProvider.value(value: groups),
    ChangeNotifierProvider.value(value: schedules),
    ChangeNotifierProvider.value(value: profile),
  ];

  void _switchUser() {
    for (final repository in [groups, schedules, profile]) {
      repository.switchUser(auth.userId);
    }
  }
}
