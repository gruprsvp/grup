import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';

import 'supabase.dart';

class MembersRepository extends SupabaseRepository {
  const MembersRepository({required super.repository});

  Future<Member> addMemberToGroup(Group group,
      {String? displayName, String? profileId, GroupRoles? role}) async {
    if ((displayName == null || displayName.isEmpty) &&
        (profileId == null || profileId.isEmpty)) {
      throw ArgumentError(
          'Either displayName or profileId must be provided to addMemberToGroup');
    }

    final profile = profileId != null
        ? await repository
            .get<Profile>(
              query: Query.where('id', profileId),
            )
            .then((profiles) => profiles.first)
        : null;

    return repository.upsert(
      Member(
        group: group,
        displayNameOverride: displayName,
        profile: profile,
        role: role ?? GroupRoles.member,
      ),
    );
  }

  Future<Member> updateMember(Member member) async {
    return repository.upsert(member);
  }

  Future<bool> deleteMember(Member member) async {
    return repository.delete<Member>(member,
        query: Query.where('id', member.id));
  }

  Future<Member> getMember(String memberId) async {
    return repository
        .get<Member>(
          query: Query.where('id', memberId),
        )
        .then((members) => members.first);
  }

  Future<Iterable<Member>> getMembersByGroupId(String groupId) async =>
      repository.get<Member>(
          query: Query.where('group', Where.exact('id', groupId)));

  Future<Member> getOwnMemberByGroupId(String groupId) async {
    final currentUserId = repository.remoteProvider.client.auth.currentUser!.id;
    return repository
        .get<Member>(
          query: Query(
            where: [
              Where.exact('group', Where.exact('id', groupId)),
              Where.exact('profile', Where.exact('id', currentUserId)),
            ],
          ),
        )
        .then((members) => members.first);
  }
}
