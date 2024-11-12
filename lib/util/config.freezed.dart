// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return _Config.fromJson(json);
}

/// @nodoc
mixin _$Config {
  String get supabaseConfigPath => throw _privateConstructorUsedError;
  String get socialAuthWebClientId => throw _privateConstructorUsedError;
  String get socialAuthIosClientId => throw _privateConstructorUsedError;
  String get revenuecatGoogleApiKey => throw _privateConstructorUsedError;
  String get revenuecatAppleApiKey => throw _privateConstructorUsedError;

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigCopyWith<Config> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCopyWith<$Res> {
  factory $ConfigCopyWith(Config value, $Res Function(Config) then) =
      _$ConfigCopyWithImpl<$Res, Config>;
  @useResult
  $Res call(
      {String supabaseConfigPath,
      String socialAuthWebClientId,
      String socialAuthIosClientId,
      String revenuecatGoogleApiKey,
      String revenuecatAppleApiKey});
}

/// @nodoc
class _$ConfigCopyWithImpl<$Res, $Val extends Config>
    implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supabaseConfigPath = null,
    Object? socialAuthWebClientId = null,
    Object? socialAuthIosClientId = null,
    Object? revenuecatGoogleApiKey = null,
    Object? revenuecatAppleApiKey = null,
  }) {
    return _then(_value.copyWith(
      supabaseConfigPath: null == supabaseConfigPath
          ? _value.supabaseConfigPath
          : supabaseConfigPath // ignore: cast_nullable_to_non_nullable
              as String,
      socialAuthWebClientId: null == socialAuthWebClientId
          ? _value.socialAuthWebClientId
          : socialAuthWebClientId // ignore: cast_nullable_to_non_nullable
              as String,
      socialAuthIosClientId: null == socialAuthIosClientId
          ? _value.socialAuthIosClientId
          : socialAuthIosClientId // ignore: cast_nullable_to_non_nullable
              as String,
      revenuecatGoogleApiKey: null == revenuecatGoogleApiKey
          ? _value.revenuecatGoogleApiKey
          : revenuecatGoogleApiKey // ignore: cast_nullable_to_non_nullable
              as String,
      revenuecatAppleApiKey: null == revenuecatAppleApiKey
          ? _value.revenuecatAppleApiKey
          : revenuecatAppleApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigImplCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$$ConfigImplCopyWith(
          _$ConfigImpl value, $Res Function(_$ConfigImpl) then) =
      __$$ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String supabaseConfigPath,
      String socialAuthWebClientId,
      String socialAuthIosClientId,
      String revenuecatGoogleApiKey,
      String revenuecatAppleApiKey});
}

/// @nodoc
class __$$ConfigImplCopyWithImpl<$Res>
    extends _$ConfigCopyWithImpl<$Res, _$ConfigImpl>
    implements _$$ConfigImplCopyWith<$Res> {
  __$$ConfigImplCopyWithImpl(
      _$ConfigImpl _value, $Res Function(_$ConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? supabaseConfigPath = null,
    Object? socialAuthWebClientId = null,
    Object? socialAuthIosClientId = null,
    Object? revenuecatGoogleApiKey = null,
    Object? revenuecatAppleApiKey = null,
  }) {
    return _then(_$ConfigImpl(
      supabaseConfigPath: null == supabaseConfigPath
          ? _value.supabaseConfigPath
          : supabaseConfigPath // ignore: cast_nullable_to_non_nullable
              as String,
      socialAuthWebClientId: null == socialAuthWebClientId
          ? _value.socialAuthWebClientId
          : socialAuthWebClientId // ignore: cast_nullable_to_non_nullable
              as String,
      socialAuthIosClientId: null == socialAuthIosClientId
          ? _value.socialAuthIosClientId
          : socialAuthIosClientId // ignore: cast_nullable_to_non_nullable
              as String,
      revenuecatGoogleApiKey: null == revenuecatGoogleApiKey
          ? _value.revenuecatGoogleApiKey
          : revenuecatGoogleApiKey // ignore: cast_nullable_to_non_nullable
              as String,
      revenuecatAppleApiKey: null == revenuecatAppleApiKey
          ? _value.revenuecatAppleApiKey
          : revenuecatAppleApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigImpl with DiagnosticableTreeMixin implements _Config {
  const _$ConfigImpl(
      {required this.supabaseConfigPath,
      required this.socialAuthWebClientId,
      required this.socialAuthIosClientId,
      required this.revenuecatGoogleApiKey,
      required this.revenuecatAppleApiKey});

  factory _$ConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConfigImplFromJson(json);

  @override
  final String supabaseConfigPath;
  @override
  final String socialAuthWebClientId;
  @override
  final String socialAuthIosClientId;
  @override
  final String revenuecatGoogleApiKey;
  @override
  final String revenuecatAppleApiKey;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Config(supabaseConfigPath: $supabaseConfigPath, socialAuthWebClientId: $socialAuthWebClientId, socialAuthIosClientId: $socialAuthIosClientId, revenuecatGoogleApiKey: $revenuecatGoogleApiKey, revenuecatAppleApiKey: $revenuecatAppleApiKey)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Config'))
      ..add(DiagnosticsProperty('supabaseConfigPath', supabaseConfigPath))
      ..add(DiagnosticsProperty('socialAuthWebClientId', socialAuthWebClientId))
      ..add(DiagnosticsProperty('socialAuthIosClientId', socialAuthIosClientId))
      ..add(
          DiagnosticsProperty('revenuecatGoogleApiKey', revenuecatGoogleApiKey))
      ..add(
          DiagnosticsProperty('revenuecatAppleApiKey', revenuecatAppleApiKey));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigImpl &&
            (identical(other.supabaseConfigPath, supabaseConfigPath) ||
                other.supabaseConfigPath == supabaseConfigPath) &&
            (identical(other.socialAuthWebClientId, socialAuthWebClientId) ||
                other.socialAuthWebClientId == socialAuthWebClientId) &&
            (identical(other.socialAuthIosClientId, socialAuthIosClientId) ||
                other.socialAuthIosClientId == socialAuthIosClientId) &&
            (identical(other.revenuecatGoogleApiKey, revenuecatGoogleApiKey) ||
                other.revenuecatGoogleApiKey == revenuecatGoogleApiKey) &&
            (identical(other.revenuecatAppleApiKey, revenuecatAppleApiKey) ||
                other.revenuecatAppleApiKey == revenuecatAppleApiKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      supabaseConfigPath,
      socialAuthWebClientId,
      socialAuthIosClientId,
      revenuecatGoogleApiKey,
      revenuecatAppleApiKey);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      __$$ConfigImplCopyWithImpl<_$ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigImplToJson(
      this,
    );
  }
}

abstract class _Config implements Config {
  const factory _Config(
      {required final String supabaseConfigPath,
      required final String socialAuthWebClientId,
      required final String socialAuthIosClientId,
      required final String revenuecatGoogleApiKey,
      required final String revenuecatAppleApiKey}) = _$ConfigImpl;

  factory _Config.fromJson(Map<String, dynamic> json) = _$ConfigImpl.fromJson;

  @override
  String get supabaseConfigPath;
  @override
  String get socialAuthWebClientId;
  @override
  String get socialAuthIosClientId;
  @override
  String get revenuecatGoogleApiKey;
  @override
  String get revenuecatAppleApiKey;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
