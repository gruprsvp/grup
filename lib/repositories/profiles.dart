import 'package:parousia/models/models.dart';
import 'package:supabase/supabase.dart';

import 'const.dart';

class ProfilesRepository {
  const ProfilesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Profile> getProfileById(String id) async {
    return _table()
        .select<PostgrestMap>()
        .eq('id', id)
        .single()
        .withConverter(Profile.fromJson);
  }

  Future<void> updateProfile({
    required String id,
    String? displayName,
    String? pictureUrl,
  }) async {
    return _table().update({
      if (displayName != null) 'display_name': displayName,
      if (pictureUrl != null) 'picture': pictureUrl,
    }).eq('id', id);
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.profiles.name);
}
