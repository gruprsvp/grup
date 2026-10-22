import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:base32/encodings.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'const.dart';
import 'supabase.dart';

class InvitesService extends SupabaseService with Postgrest {
  const InvitesService({required super.supabase})
    : super(tableName: Tables.invites);

  // Invite codes are bearer credentials that grant group membership — they
  // must come from a CSPRNG, not the time-seeded default Random().
  static final _codeRandom = Random.secure();

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
      Uint8List.fromList(List.generate(5, (_) => _codeRandom.nextInt(256))),
      encoding: Encoding.crockford,
    );
    final formatted = formatBase32Code(code);
    return inviteMember(memberId, InviteMethods.code, formatted);
  }

  Future<String> checkInviteCode(String code) async {
    return supabase.rpc('check_invite_code', params: {'code': code});
  }

  Future<void> consumeInviteCode(String code) async {
    try {
      await supabase.rpc('consume_invite_code', params: {'code': code});
    } on PostgrestException catch (e) {
      // no_data_found: check_invite_code's `select ... into strict` found no
      // invite with this code.
      if (e.code == 'P0002') throw const InvalidInviteCodeException();
      // unique_violation on members (group_id, profile_id): the user already
      // belongs to the group this code is for.
      if (e.code == '23505') throw const AlreadyMemberException();
      rethrow;
    }
  }

  Future<List<Invite>> getInvitesForMember(String memberId) async {
    return table()
        .select()
        .eq('member_id', memberId)
        .withConverter((data) => decodeRows(data, Invite.fromJson));
  }
}
