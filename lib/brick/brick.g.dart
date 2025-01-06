// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_core/query.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/db.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_sqlite/brick_sqlite.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:brick_supabase/brick_supabase.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:uuid/v7.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:dart_mappable/dart_mappable.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:parousia/brick/models/member.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:parousia/brick/models/schedule.model.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:parousia/models/models.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:parousia/brick/brick.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:rrule/rrule.dart';
// ignore: unused_import, unused_shown_name, unnecessary_import
import 'package:parousia/brick/models/group.model.dart';// GENERATED CODE DO NOT EDIT
// ignore: unused_import
import 'dart:convert';
import 'package:brick_sqlite/brick_sqlite.dart' show SqliteModel, SqliteAdapter, SqliteModelDictionary, RuntimeSqliteColumnDefinition, SqliteProvider;
import 'package:brick_supabase/brick_supabase.dart' show SupabaseProvider, SupabaseModel, SupabaseAdapter, SupabaseModelDictionary;
// ignore: unused_import, unused_shown_name
import 'package:brick_offline_first/brick_offline_first.dart' show RuntimeOfflineFirstDefinition;
// ignore: unused_import, unused_shown_name
import 'package:sqflite_common/sqlite_api.dart' show DatabaseExecutor;

import '../brick/models/group.model.dart';
import '../brick/models/default_rule.model.dart';
import '../brick/models/invite.model.dart';
import '../brick/models/schedule.model.dart';
import '../brick/models/member.model.dart';
import '../brick/models/profile.model.dart';
import '../brick/models/reply.model.dart';

part 'adapters/group_adapter.g.dart';
part 'adapters/default_rule_adapter.g.dart';
part 'adapters/invite_adapter.g.dart';
part 'adapters/schedule_adapter.g.dart';
part 'adapters/member_adapter.g.dart';
part 'adapters/profile_adapter.g.dart';
part 'adapters/reply_adapter.g.dart';

/// Supabase mappings should only be used when initializing a [SupabaseProvider]
final Map<Type, SupabaseAdapter<SupabaseModel>> supabaseMappings = {
  Group: GroupAdapter(),
  DefaultRule: DefaultRuleAdapter(),
  Invite: InviteAdapter(),
  Schedule: ScheduleAdapter(),
  Member: MemberAdapter(),
  Profile: ProfileAdapter(),
  Reply: ReplyAdapter()
};
final supabaseModelDictionary = SupabaseModelDictionary(supabaseMappings);

/// Sqlite mappings should only be used when initializing a [SqliteProvider]
final Map<Type, SqliteAdapter<SqliteModel>> sqliteMappings = {
  Group: GroupAdapter(),
  DefaultRule: DefaultRuleAdapter(),
  Invite: InviteAdapter(),
  Schedule: ScheduleAdapter(),
  Member: MemberAdapter(),
  Profile: ProfileAdapter(),
  Reply: ReplyAdapter()
};
final sqliteModelDictionary = SqliteModelDictionary(sqliteMappings);
