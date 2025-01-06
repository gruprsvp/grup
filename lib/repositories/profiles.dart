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

  Future<UserResponse> updateProfile({
    required String id,
    String? displayName,
    String? pictureUrl,
  }) async {
    final supabaseClient = repository.remoteProvider.client;
    return await supabaseClient.auth.updateUser(UserAttributes(data: {
      if (displayName != null) 'full_name': displayName,
      if (pictureUrl != null) 'avatar_url': pictureUrl,
    }));
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
