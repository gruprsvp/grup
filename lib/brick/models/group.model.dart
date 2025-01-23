import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/v7.dart';

part 'group.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'groups',
  ),
)
@MappableClass()
class Group extends OfflineFirstWithSupabaseModel with GroupMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String displayName;
  final String? description;
  final String? picture;

  Group({
    required this.displayName,
    this.description,
    this.picture,
    String? id,
  }) : id = id ?? const UuidV7().generate();
}
