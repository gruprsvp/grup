import 'dart:developer';

import 'package:sentry_flutter/sentry_flutter.dart';
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
  PostgrestQueryBuilder<void> table() => supabase.rest.from(tableName!.table);
}

mixin Storage on SupabaseService {
  StorageFileApi bucket() => supabase.storage.from(bucketName!.name);
}

/// Decodes [rows], skipping (and reporting) the ones that don't decode.
///
/// The database is shared by every installed app version: a value added to a
/// server enum after this version shipped must cost that one row, not the
/// whole list.
List<T> decodeRows<T>(
  Iterable<Map<String, dynamic>> rows,
  T Function(Map<String, dynamic> json) fromJson,
) => [
  for (final row in rows)
    if (_tryDecode(row, fromJson) case final T value) value,
];

T? _tryDecode<T>(
  Map<String, dynamic> row,
  T Function(Map<String, dynamic> json) fromJson,
) {
  try {
    return fromJson(row);
  } catch (error, stackTrace) {
    log('Skipped a row: $error', name: 'parousia', stackTrace: stackTrace);
    Sentry.captureException(error, stackTrace: stackTrace);
    return null;
  }
}
