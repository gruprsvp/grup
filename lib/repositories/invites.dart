import 'package:parousia/models/models.dart';

import 'const.dart';
import 'supabase.dart';

class InvitesRepository extends SupabaseRepository with Postgrest {
  const InvitesRepository({required super.supabase})
      : super(tableName: Tables.invites);

  Future<Invite> inviteMember(
    int memberId,
    InviteMethods method,
    String value,
  ) async {
    return table()
        .insert({
          'member_id': memberId,
          'method': method.name,
          'value': value,
        })
        .select()
        .single()
        .withConverter((data) => Invite.fromJson(data));
  }

  Future<void> consumeInviteCode(String code) async {
    return supabase.rpc('consume_invite_code', params: {'code': code});
  }
}
