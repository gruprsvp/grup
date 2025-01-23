import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/brick/models/member.model.dart';
import 'package:parousia/models/models.dart';
import 'package:uuid/v7.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'invites',
  ),
)
class Invite extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true, index: true)
  final String id;

  @Supabase(foreignKey: 'member_id', ignoreTo: true)
  final Member member;

  @Sqlite(ignore: true)
  String get memberId => member.id;

  @Supabase(enumAsString: true)
  final InviteMethods method;
  final String value;

  Invite({
    required this.member,
    required this.method,
    required this.value,
    String? id,
  }) : id = id ?? const UuidV7().generate();
}
