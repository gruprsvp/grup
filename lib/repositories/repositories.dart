import 'package:parousia/data/groups.dart';
import 'package:parousia/models/models.dart';

class GroupsRepository {
  DataProviderGroups groups;

  GroupsRepository({required this.groups});

  Future<Iterable<Group>> getUserGroups() async {
    return groups.getUserGroups();
  }

  // TODO(borgoat): return type
  Future<dynamic> createGroup(String displayName) async {
    // return supabase.rest.rpc(
    //   'create_group',
    //   params: {'display_name': displayName},
    // );
  }
}
