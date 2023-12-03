import 'package:parousia/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

class InvitesRepository {
  InvitesRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<Invite> inviteMember(
    int memberId,
    InviteMethods method,
    String value,
  ) async {
    return _table()
        .insert({
          'member_id': memberId,
          'method': method.name,
          'value': value,
        })
        .select()
        .single()
        .withConverter((data) => Invite.fromJson(data));
  }

  PostgrestQueryBuilder<void> _table() =>
      supabase.rest.from(Tables.invites.name);
}
