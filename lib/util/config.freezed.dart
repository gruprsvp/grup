// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Config implements DiagnosticableTreeMixin {

 String get supabaseConfigPath; String get socialAuthWebClientId; String get socialAuthIosClientId;
/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigCopyWith<Config> get copyWith => _$ConfigCopyWithImpl<Config>(this as Config, _$identity);

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Config'))
    ..add(DiagnosticsProperty('supabaseConfigPath', supabaseConfigPath))..add(DiagnosticsProperty('socialAuthWebClientId', socialAuthWebClientId))..add(DiagnosticsProperty('socialAuthIosClientId', socialAuthIosClientId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Config&&(identical(other.supabaseConfigPath, supabaseConfigPath) || other.supabaseConfigPath == supabaseConfigPath)&&(identical(other.socialAuthWebClientId, socialAuthWebClientId) || other.socialAuthWebClientId == socialAuthWebClientId)&&(identical(other.socialAuthIosClientId, socialAuthIosClientId) || other.socialAuthIosClientId == socialAuthIosClientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supabaseConfigPath,socialAuthWebClientId,socialAuthIosClientId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Config(supabaseConfigPath: $supabaseConfigPath, socialAuthWebClientId: $socialAuthWebClientId, socialAuthIosClientId: $socialAuthIosClientId)';
}


}

/// @nodoc
abstract mixin class $ConfigCopyWith<$Res>  {
  factory $ConfigCopyWith(Config value, $Res Function(Config) _then) = _$ConfigCopyWithImpl;
@useResult
$Res call({
 String supabaseConfigPath, String socialAuthWebClientId, String socialAuthIosClientId
});




}
/// @nodoc
class _$ConfigCopyWithImpl<$Res>
    implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._self, this._then);

  final Config _self;
  final $Res Function(Config) _then;

/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supabaseConfigPath = null,Object? socialAuthWebClientId = null,Object? socialAuthIosClientId = null,}) {
  return _then(_self.copyWith(
supabaseConfigPath: null == supabaseConfigPath ? _self.supabaseConfigPath : supabaseConfigPath // ignore: cast_nullable_to_non_nullable
as String,socialAuthWebClientId: null == socialAuthWebClientId ? _self.socialAuthWebClientId : socialAuthWebClientId // ignore: cast_nullable_to_non_nullable
as String,socialAuthIosClientId: null == socialAuthIosClientId ? _self.socialAuthIosClientId : socialAuthIosClientId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Config].
extension ConfigPatterns on Config {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Config value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Config value)  $default,){
final _that = this;
switch (_that) {
case _Config():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Config value)?  $default,){
final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String supabaseConfigPath,  String socialAuthWebClientId,  String socialAuthIosClientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that.supabaseConfigPath,_that.socialAuthWebClientId,_that.socialAuthIosClientId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String supabaseConfigPath,  String socialAuthWebClientId,  String socialAuthIosClientId)  $default,) {final _that = this;
switch (_that) {
case _Config():
return $default(_that.supabaseConfigPath,_that.socialAuthWebClientId,_that.socialAuthIosClientId);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String supabaseConfigPath,  String socialAuthWebClientId,  String socialAuthIosClientId)?  $default,) {final _that = this;
switch (_that) {
case _Config() when $default != null:
return $default(_that.supabaseConfigPath,_that.socialAuthWebClientId,_that.socialAuthIosClientId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Config with DiagnosticableTreeMixin implements Config {
  const _Config({required this.supabaseConfigPath, required this.socialAuthWebClientId, required this.socialAuthIosClientId});
  factory _Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

@override final  String supabaseConfigPath;
@override final  String socialAuthWebClientId;
@override final  String socialAuthIosClientId;

/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigCopyWith<_Config> get copyWith => __$ConfigCopyWithImpl<_Config>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Config'))
    ..add(DiagnosticsProperty('supabaseConfigPath', supabaseConfigPath))..add(DiagnosticsProperty('socialAuthWebClientId', socialAuthWebClientId))..add(DiagnosticsProperty('socialAuthIosClientId', socialAuthIosClientId));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Config&&(identical(other.supabaseConfigPath, supabaseConfigPath) || other.supabaseConfigPath == supabaseConfigPath)&&(identical(other.socialAuthWebClientId, socialAuthWebClientId) || other.socialAuthWebClientId == socialAuthWebClientId)&&(identical(other.socialAuthIosClientId, socialAuthIosClientId) || other.socialAuthIosClientId == socialAuthIosClientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supabaseConfigPath,socialAuthWebClientId,socialAuthIosClientId);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Config(supabaseConfigPath: $supabaseConfigPath, socialAuthWebClientId: $socialAuthWebClientId, socialAuthIosClientId: $socialAuthIosClientId)';
}


}

/// @nodoc
abstract mixin class _$ConfigCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$ConfigCopyWith(_Config value, $Res Function(_Config) _then) = __$ConfigCopyWithImpl;
@override @useResult
$Res call({
 String supabaseConfigPath, String socialAuthWebClientId, String socialAuthIosClientId
});




}
/// @nodoc
class __$ConfigCopyWithImpl<$Res>
    implements _$ConfigCopyWith<$Res> {
  __$ConfigCopyWithImpl(this._self, this._then);

  final _Config _self;
  final $Res Function(_Config) _then;

/// Create a copy of Config
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supabaseConfigPath = null,Object? socialAuthWebClientId = null,Object? socialAuthIosClientId = null,}) {
  return _then(_Config(
supabaseConfigPath: null == supabaseConfigPath ? _self.supabaseConfigPath : supabaseConfigPath // ignore: cast_nullable_to_non_nullable
as String,socialAuthWebClientId: null == socialAuthWebClientId ? _self.socialAuthWebClientId : socialAuthWebClientId // ignore: cast_nullable_to_non_nullable
as String,socialAuthIosClientId: null == socialAuthIosClientId ? _self.socialAuthIosClientId : socialAuthIosClientId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
