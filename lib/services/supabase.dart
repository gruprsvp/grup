import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

abstract class SupabaseService {
  final SupabaseClient supabase;
  final Tables? tableName;
  final Buckets? bucketName;

  const SupabaseService({
    required this.supabase,
    this.tableName,
    this.bucketName,
  });
}

mixin Postgrest on SupabaseService {
  PostgrestQueryBuilder<void> table() => supabase.rest.from(tableName!.name);
}

mixin Storage on SupabaseService {
  StorageFileApi bucket() => supabase.storage.from(bucketName!.name);
}
