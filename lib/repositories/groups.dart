import 'package:parousia/models/models.dart';
import 'package:supabase/supabase.dart';

import 'tables.dart';

class GroupsRepository {
  GroupsRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Iterable<Group>> getUserGroups() async {
    return _table()
        .select<PostgrestList>('*, members!inner(*)')
        .eq('members.profile_id', 'auth.uid()')
        .withConverter((data) => data.map(Group.fromJson));
  }

  Future<Group> getGroupById(int id) async {
    return _table()
        .select<PostgrestMap>()
        .eq('id', id)
        .single()
        .withConverter(Group.fromJson);
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.groups.name);
}
