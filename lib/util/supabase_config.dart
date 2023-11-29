import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';

part 'supabase_config.freezed.dart';
part 'supabase_config.g.dart';

@freezed
class SupabaseConfig with _$SupabaseConfig {
  @JsonSerializable(fieldRename: FieldRename.screamingSnake)
  const factory SupabaseConfig({
    required String anonKey,
    required String apiUrl,
    required String dbUrl,
    required String graphqlUrl,
    required String inbucketUrl,
    required String jwtSecret,
    required String serviceRoleKey,
    required String studioUrl,
  }) = _SupabaseConfig;

  factory SupabaseConfig.fromJson(Map<String, dynamic> json) =>
      _$SupabaseConfigFromJson(json);

  factory SupabaseConfig.fromString(String jsonString) =>
      SupabaseConfig.fromJson(jsonDecode(jsonString));

  factory SupabaseConfig.fromFile(File file) =>
      SupabaseConfig.fromString(file.readAsStringSync());

  factory SupabaseConfig.fromPath(String path) =>
      SupabaseConfig.fromFile(File(path));
}
