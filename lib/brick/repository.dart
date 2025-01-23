import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' show databaseFactory;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'brick.g.dart';
import 'db/schema.g.dart';

class ParRepository extends OfflineFirstWithSupabaseRepository {
  static late ParRepository? _singleton;

  ParRepository._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  factory ParRepository() => _singleton!;

  static Future<void> configure({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    // Convenience method `.clientQueue` makes creating the queue and client easy.
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
    );

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      httpClient: client,
    );

    final provider = SupabaseProvider(
      SupabaseClient(supabaseUrl, supabaseAnonKey, httpClient: client),
      modelDictionary: supabaseModelDictionary,
    );

    // Finally, initialize the repository as normal.
    _singleton = ParRepository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'par_repository.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }
}
