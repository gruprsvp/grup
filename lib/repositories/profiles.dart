import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';
import 'package:supabase/supabase.dart';

import 'supabase.dart';

class ProfilesRepository extends SupabaseRepository {
  const ProfilesRepository({required super.repository});

  Future<Profile> getProfile(String profileId) async {
    return repository
        .get<Profile>(query: Query.where('id', profileId))
        .then((profiles) => profiles.first);
  }

  Future<Profile> updateProfile(Profile profile) async {
    final displayName = profile.displayName;
    final pictureUrl = profile.picture;
    final supabaseClient = repository.remoteProvider.client;
    await supabaseClient.auth.updateUser(UserAttributes(data: {
      if (displayName != null) 'full_name': displayName,
      if (pictureUrl != null) 'avatar_url': pictureUrl,
    }));

    return repository.upsert(profile);
  }

  Future<void> deleteProfile() async {
    final supabaseClient = repository.remoteProvider.client;
    await supabaseClient.functions.invoke('delete_user_account');
  }

  Future<void> signOut() async {
    final supabaseClient = repository.remoteProvider.client;
    await supabaseClient.auth.signOut(scope: SignOutScope.global);
  }
}
