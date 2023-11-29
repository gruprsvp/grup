// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supabase_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SupabaseConfigImpl _$$SupabaseConfigImplFromJson(Map<String, dynamic> json) =>
    _$SupabaseConfigImpl(
      anonKey: json['ANON_KEY'] as String,
      apiUrl: json['API_URL'] as String,
      dbUrl: json['DB_URL'] as String,
      graphqlUrl: json['GRAPHQL_URL'] as String,
      inbucketUrl: json['INBUCKET_URL'] as String,
      jwtSecret: json['JWT_SECRET'] as String,
      serviceRoleKey: json['SERVICE_ROLE_KEY'] as String,
      studioUrl: json['STUDIO_URL'] as String,
    );

Map<String, dynamic> _$$SupabaseConfigImplToJson(
        _$SupabaseConfigImpl instance) =>
    <String, dynamic>{
      'ANON_KEY': instance.anonKey,
      'API_URL': instance.apiUrl,
      'DB_URL': instance.dbUrl,
      'GRAPHQL_URL': instance.graphqlUrl,
      'INBUCKET_URL': instance.inbucketUrl,
      'JWT_SECRET': instance.jwtSecret,
      'SERVICE_ROLE_KEY': instance.serviceRoleKey,
      'STUDIO_URL': instance.studioUrl,
    };
