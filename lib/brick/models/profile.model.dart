import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'profile.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'profiles',
  ),
)
@MappableClass()
class Profile extends OfflineFirstWithSupabaseModel with ProfileMappable {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  final String? displayName;
  final String? picture;

  Profile({
    required this.id,
    this.displayName,
    this.picture,
  });

  static final fromJson = ProfileMapper.fromJson;
}
