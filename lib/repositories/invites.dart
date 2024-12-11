import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:base32/encodings.dart';
import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/util.dart';

import 'supabase.dart';

class InvitesRepository extends SupabaseRepository {
  const InvitesRepository({required super.repository});

  Future<Invite> inviteMember(Invite invite) async {
    return repository.upsert<Invite>(invite);
  }

  Future<Invite> inviteWithGeneratedCode(Member member) async {
    final code = base32.encode(
        Uint8List.fromList(List.generate(5, (_) => Random().nextInt(256))),
        encoding: Encoding.crockford);
    final formatted = formatBase32Code(code);
    return inviteMember(
      Invite(member: member, method: InviteMethods.code, value: formatted),
    );
  }

  Future<int> checkInviteCode(String code) async {
    return repository.remoteProvider.client
        .rpc('check_invite_code', params: {'code': code});
  }

  Future<void> consumeInviteCode(String code) async {
    return repository.remoteProvider.client
        .rpc('consume_invite_code', params: {'code': code});
  }

  Future<Iterable<Invite>> getInvitesForMember(int memberId) async {
    return repository.get<Invite>(
      query: Query(where: [
        Where('member_id').isExactly(memberId),
      ]),
    );
  }
}
