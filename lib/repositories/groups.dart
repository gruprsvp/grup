import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class GroupsRepository extends SupabaseRepository {
  GroupsRepository({required super.repository});

  Future<Iterable<Group>> getUserGroups() async {
    return repository.get<Group>(
      query: Query(where: [
        Where('member').isExactly(
          Where('id')
              // ! This is a bit of a hack to get the current user's ID...
              .isExactly(repository.remoteProvider.client.auth.currentUser!.id),
        ),
      ]),
    );
  }

  Future<Group> getGroup(String groupId) async {
    final list = await repository.get<Group>(
      query: Query.where('id', groupId),
    );
    return list.first;
  }

  Future<Group> createGroup(Group group) async {
    return repository.upsert(group);
  }

  Future<Group> updateGroup(Group group) async {
    return repository.upsert(group);
  }

  Future<bool> deleteGroup(Group group) async {
    return repository.delete(group);
  }
}
