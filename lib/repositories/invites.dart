import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:base32/encodings.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class InvitesRepository extends SupabaseRepository with Postgrest {
  const InvitesRepository({required super.supabase})
      : super(tableName: Tables.invites);

  Future<Invite> inviteMember(
    String memberId,
    InviteMethods method,
    String value,
  ) async {
    return table()
        .insert({
          'id': const Uuid().v7(),
          'member_id': memberId,
          'method': method.name,
          'value': value,
        })
        .select()
        .single()
        .withConverter((data) => Invite.fromJson(data));
  }

  Future<Invite> inviteWithGeneratedCode(String memberId) async {
    final code = base32.encode(
        Uint8List.fromList(List.generate(5, (_) => Random().nextInt(256))),
        encoding: Encoding.crockford);
    final formatted = formatBase32Code(code);
    return inviteMember(memberId, InviteMethods.code, formatted);
  }

  Future<String> checkInviteCode(String code) async {
    return supabase.rpc('check_invite_code', params: {'code': code});
  }

  Future<void> consumeInviteCode(String code) async {
    return supabase.rpc('consume_invite_code', params: {'code': code});
  }

  Future<Iterable<Invite>> getInvitesForMember(String memberId) async {
    return table()
        .select()
        .eq('member_id', memberId)
        .withConverter((data) => data.map(Invite.fromJson));
  }
}
