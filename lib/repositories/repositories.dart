import 'package:supabase_flutter/supabase_flutter.dart';

class GroupsRepository {
  GroupsRepository({required this.supabase});

  final SupabaseClient supabase;

  // TODO(borgoat): return type
  Future<dynamic> createGroup(String displayName) async {
    return supabase.rest.rpc(
      'create_group',
      params: {'display_name': displayName},
    );
  }
}
