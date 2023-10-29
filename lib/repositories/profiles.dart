import 'package:parousia/models/models.dart';
import 'package:supabase/supabase.dart';

import 'tables.dart';

class ProfilesRepository {
  const ProfilesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Profile> getOwnProfile() async {
    if (supabase.auth.currentUser == null) {
      throw Exception('User is not logged in');
    }

    return _table()
        .select<PostgrestMap>()
        .eq('id', supabase.auth.currentUser?.id)
        .single()
        .withConverter(Profile.fromJson);
  }

  Future<Profile> getProfileById(String id) async {
    return _table()
        .select<PostgrestMap>()
        .eq('id', id)
        .single()
        .withConverter(Profile.fromJson);
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.profiles.name);
}
