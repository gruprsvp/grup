import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:uuid/v7.dart';

part 'member.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'members',
  ),
)
@MappableClass()
class Member extends OfflineFirstWithSupabaseModel with MemberMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'group_id', ignoreTo: true)
  final Group group;

  @Supabase(foreignKey: 'profile_id', ignoreTo: true)
  final Profile? profile;

  @Sqlite(ignore: true)
  String get groupId => group.id;

  @Sqlite(ignore: true)
  String? get profileId => profile?.id;

  @Supabase(enumAsString: true)
  final GroupRoles role;
  final String? displayNameOverride;

  Member({
    required this.group,
    required this.role,
    this.profile,
    this.displayNameOverride,
    String? id,
  }) : id = id ?? const UuidV7().generate();
}
