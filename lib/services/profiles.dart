import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';
import 'supabase.dart';

class ProfilesService extends SupabaseService with Postgrest {
  const ProfilesService({required super.supabase})
    : super(tableName: Tables.profiles);

  Future<Profile> getProfileById(String id) async {
    return table()
        .select()
        .eq('id', id)
        .single()
        .withConverter(Profile.fromJson);
  }

  /// Sets [id]'s name and, unless null, their picture. Writes the profile
  /// itself: auth metadata is rewritten by providers at sign-in.
  Future<Profile> updateProfile({
    required String id,
    required String displayName,
    String? pictureUrl,
  }) async {
    return table()
        .update({'display_name': displayName, 'picture': ?pictureUrl})
        .eq('id', id)
        .select()
        .single()
        .withConverter(Profile.fromJson);
  }

  Future<void> deleteProfile() async {
    await supabase.functions.invoke('delete_user_account');
  }

  Future<void> signOut() async =>
      await supabase.auth.signOut(scope: SignOutScope.global);
}
