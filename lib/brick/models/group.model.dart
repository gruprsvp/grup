import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/v7.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'groups',
  ),
)
class Group extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String displayName;
  final String? description;
  final String? picture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Group({
    required this.displayName,
    this.description,
    this.picture,
    this.createdAt,
    this.updatedAt,
    String? id,
  }) : id = id ?? const UuidV7().generate();
}
