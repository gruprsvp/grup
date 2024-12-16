import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';
import 'supabase.dart';

class ProfilesRepository extends SupabaseRepository with Postgrest {
  const ProfilesRepository({required super.supabase})
      : super(tableName: Tables.profiles);

  Future<Profile> getProfileById(String id) async {
    return table()
        .select()
        .eq('id', id)
        .single()
        .withConverter(Profile.fromJson);
  }

  Future<UserResponse> updateProfile({
    required String id,
    String? displayName,
    String? pictureUrl,
  }) async {
    return supabase.auth.updateUser(UserAttributes(data: {
      if (displayName != null) 'full_name': displayName,
      if (pictureUrl != null) 'picture': pictureUrl,
    }));
  }

  Future<void> deleteProfile() async {
    await supabase.functions.invoke('delete_user_account');
  }

  Future<void> signOut() async =>
      await supabase.auth.signOut(scope: SignOutScope.global);
}
