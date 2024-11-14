import 'package:parousia/models/models.dart';

import 'const.dart';
import 'functions.dart';
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

  Future<void> updateProfile({
    required String id,
    String? displayName,
    String? pictureUrl,
  }) async {
    return table().update({
      if (displayName != null) 'display_name': displayName,
      if (pictureUrl != null) 'picture': pictureUrl,
    }).eq('id', id);
  }

  Future<void> deleteProfile() async {
    await supabase.functions
        .deleteAccount(supabase.auth.currentSession!.accessToken);
    return table().delete().eq('id', supabase.auth.currentUser!.id);
  }
}
