import 'package:supabase_flutter/supabase_flutter.dart';

import 'const.dart';

abstract class SupabaseRepository {
  final SupabaseClient supabase;
  final Tables? tableName;
  final Buckets? bucketName;

  const SupabaseRepository({
    required this.supabase,
    this.tableName,
    this.bucketName,
  });
}

mixin Postgrest on SupabaseRepository {
  PostgrestQueryBuilder<void> table() => supabase.rest.from(tableName!.name);
}

mixin Storage on SupabaseRepository {
  bucket() => supabase.storage.from(bucketName!.name);
}
