// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      status: $enumDecode(_$AuthStatusEnumMap, json['status']),
      user: _$JsonConverterFromJson<Map<String, dynamic>, User>(
          json['user'], const UserJsonConverter().fromJson),
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'status': _$AuthStatusEnumMap[instance.status]!,
      'user': _$JsonConverterToJson<Map<String, dynamic>, User>(
          instance.user, const UserJsonConverter().toJson),
    };

const _$AuthStatusEnumMap = {
  AuthStatus.initial: 'initial',
  AuthStatus.authenticated: 'authenticated',
  AuthStatus.unauthenticated: 'unauthenticated',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
