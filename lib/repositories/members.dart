import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';

import 'supabase.dart';

class MembersRepository extends SupabaseRepository {
  const MembersRepository({required super.repository});

  Future<Member> addMemberToGroup(String groupId,
      {String? displayName, String? profileId}) async {
    if ((displayName == null || displayName.isEmpty) &&
        (profileId == null || profileId.isEmpty)) {
      throw ArgumentError(
          'Either displayName or profileId must be provided to addMemberToGroup');
    }

    final group = await repository
        .get<Group>(
          query: Query.where('id', groupId),
        )
        .then((groups) => groups.first);

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
        role: GroupRoles.member,
      ),
    );
  }

  Future<Member> updateMember(Member member) async {
    return repository.upsert(member);
  }

  Future<bool> deleteMember(String memberId) async {
    final member = await getMember(memberId);
    return repository.delete<Member>(member);
  }

  Future<Member> getMember(String memberId) async {
    return repository
        .get<Member>(
          query: Query(
            where: [
              Where('id').isExactly(memberId),
            ],
          ),
        )
        .then((members) => members.first);
  }

  Future<Iterable<Member>> getMembersByGroupId(String groupId) async =>
      repository.get<Member>(
        query: Query.where('members.group_id', groupId),
      );

  Future<Member> getOwnMemberByGroupId(String groupId) async {
    final currentUserId = repository.remoteProvider.client.auth.currentUser!.id;
    return repository
        .get<Member>(
          query: Query(
            where: [
              Where('groups.group_id').isExactly(groupId),
              Where('profiles.profile_id').isExactly(currentUserId),
            ],
          ),
        )
        .then((members) => members.first);
  }
}
