// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupabaseConfig _$SupabaseConfigFromJson(Map<String, dynamic> json) =>
    _SupabaseConfig(
      publishableKey: json['PUBLISHABLE_KEY'] as String,
      apiUrl: json['API_URL'] as String,
      dbUrl: json['DB_URL'] as String?,
      graphqlUrl: json['GRAPHQL_URL'] as String?,
      jwtSecret: json['JWT_SECRET'] as String?,
      serviceRoleKey: json['SERVICE_ROLE_KEY'] as String?,
      studioUrl: json['STUDIO_URL'] as String?,
    );

Map<String, dynamic> _$SupabaseConfigToJson(_SupabaseConfig instance) =>
    <String, dynamic>{
      'PUBLISHABLE_KEY': instance.publishableKey,
      'API_URL': instance.apiUrl,
      'DB_URL': instance.dbUrl,
      'GRAPHQL_URL': instance.graphqlUrl,
      'JWT_SECRET': instance.jwtSecret,
      'SERVICE_ROLE_KEY': instance.serviceRoleKey,
      'STUDIO_URL': instance.studioUrl,
    };
