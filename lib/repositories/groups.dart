import 'package:brick_core/core.dart';
import 'package:parousia/brick/brick.dart';

import 'supabase.dart';

class GroupsRepository extends SupabaseRepository {
  GroupsRepository({required super.repository});

  Future<Iterable<Group>> getUserGroups() async => repository.get<Group>();

  Future<Group> getGroup(String groupId) async {
    final list = await repository.get<Group>(query: Query.where('id', groupId));
    return list.first;
  }

  Future<Group> createGroup(Group group) async {
    await repository.remoteProvider.client.rpc(
      'create_group',
      params: {
        'id': group.id,
        'display_name': group.displayName,
        'description': group.description,
        'picture': group.picture,
      },
    );
    return repository.upsert(group);
  }

  Future<Group> updateGroup(Group group) async {
    return repository.upsert(group);
  }

  Future<bool> deleteGroup(Group group) async {
    return repository.delete(group);
  }
}
