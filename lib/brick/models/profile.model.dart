import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'profiles',
  ),
)
class Profile extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final String id;

  final String? displayName;
  final String? picture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    this.displayName,
    this.picture,
    this.createdAt,
    this.updatedAt,
  });
}
