// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supabase_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupabaseConfig implements DiagnosticableTreeMixin {

 String get anonKey; String get apiUrl; String? get dbUrl; String? get graphqlUrl; String? get inbucketUrl; String? get jwtSecret; String? get serviceRoleKey; String? get studioUrl;
/// Create a copy of SupabaseConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupabaseConfigCopyWith<SupabaseConfig> get copyWith => _$SupabaseConfigCopyWithImpl<SupabaseConfig>(this as SupabaseConfig, _$identity);

  /// Serializes this SupabaseConfig to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SupabaseConfig'))
    ..add(DiagnosticsProperty('anonKey', anonKey))..add(DiagnosticsProperty('apiUrl', apiUrl))..add(DiagnosticsProperty('dbUrl', dbUrl))..add(DiagnosticsProperty('graphqlUrl', graphqlUrl))..add(DiagnosticsProperty('inbucketUrl', inbucketUrl))..add(DiagnosticsProperty('jwtSecret', jwtSecret))..add(DiagnosticsProperty('serviceRoleKey', serviceRoleKey))..add(DiagnosticsProperty('studioUrl', studioUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupabaseConfig&&(identical(other.anonKey, anonKey) || other.anonKey == anonKey)&&(identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl)&&(identical(other.dbUrl, dbUrl) || other.dbUrl == dbUrl)&&(identical(other.graphqlUrl, graphqlUrl) || other.graphqlUrl == graphqlUrl)&&(identical(other.inbucketUrl, inbucketUrl) || other.inbucketUrl == inbucketUrl)&&(identical(other.jwtSecret, jwtSecret) || other.jwtSecret == jwtSecret)&&(identical(other.serviceRoleKey, serviceRoleKey) || other.serviceRoleKey == serviceRoleKey)&&(identical(other.studioUrl, studioUrl) || other.studioUrl == studioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonKey,apiUrl,dbUrl,graphqlUrl,inbucketUrl,jwtSecret,serviceRoleKey,studioUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SupabaseConfig(anonKey: $anonKey, apiUrl: $apiUrl, dbUrl: $dbUrl, graphqlUrl: $graphqlUrl, inbucketUrl: $inbucketUrl, jwtSecret: $jwtSecret, serviceRoleKey: $serviceRoleKey, studioUrl: $studioUrl)';
}


}

/// @nodoc
abstract mixin class $SupabaseConfigCopyWith<$Res>  {
  factory $SupabaseConfigCopyWith(SupabaseConfig value, $Res Function(SupabaseConfig) _then) = _$SupabaseConfigCopyWithImpl;
@useResult
$Res call({
 String anonKey, String apiUrl, String? dbUrl, String? graphqlUrl, String? inbucketUrl, String? jwtSecret, String? serviceRoleKey, String? studioUrl
});




}
/// @nodoc
class _$SupabaseConfigCopyWithImpl<$Res>
    implements $SupabaseConfigCopyWith<$Res> {
  _$SupabaseConfigCopyWithImpl(this._self, this._then);

  final SupabaseConfig _self;
  final $Res Function(SupabaseConfig) _then;

/// Create a copy of SupabaseConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anonKey = null,Object? apiUrl = null,Object? dbUrl = freezed,Object? graphqlUrl = freezed,Object? inbucketUrl = freezed,Object? jwtSecret = freezed,Object? serviceRoleKey = freezed,Object? studioUrl = freezed,}) {
  return _then(_self.copyWith(
anonKey: null == anonKey ? _self.anonKey : anonKey // ignore: cast_nullable_to_non_nullable
as String,apiUrl: null == apiUrl ? _self.apiUrl : apiUrl // ignore: cast_nullable_to_non_nullable
as String,dbUrl: freezed == dbUrl ? _self.dbUrl : dbUrl // ignore: cast_nullable_to_non_nullable
as String?,graphqlUrl: freezed == graphqlUrl ? _self.graphqlUrl : graphqlUrl // ignore: cast_nullable_to_non_nullable
as String?,inbucketUrl: freezed == inbucketUrl ? _self.inbucketUrl : inbucketUrl // ignore: cast_nullable_to_non_nullable
as String?,jwtSecret: freezed == jwtSecret ? _self.jwtSecret : jwtSecret // ignore: cast_nullable_to_non_nullable
as String?,serviceRoleKey: freezed == serviceRoleKey ? _self.serviceRoleKey : serviceRoleKey // ignore: cast_nullable_to_non_nullable
as String?,studioUrl: freezed == studioUrl ? _self.studioUrl : studioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupabaseConfig].
extension SupabaseConfigPatterns on SupabaseConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupabaseConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupabaseConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupabaseConfig value)  $default,){
final _that = this;
switch (_that) {
case _SupabaseConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupabaseConfig value)?  $default,){
final _that = this;
switch (_that) {
case _SupabaseConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String anonKey,  String apiUrl,  String? dbUrl,  String? graphqlUrl,  String? inbucketUrl,  String? jwtSecret,  String? serviceRoleKey,  String? studioUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupabaseConfig() when $default != null:
return $default(_that.anonKey,_that.apiUrl,_that.dbUrl,_that.graphqlUrl,_that.inbucketUrl,_that.jwtSecret,_that.serviceRoleKey,_that.studioUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String anonKey,  String apiUrl,  String? dbUrl,  String? graphqlUrl,  String? inbucketUrl,  String? jwtSecret,  String? serviceRoleKey,  String? studioUrl)  $default,) {final _that = this;
switch (_that) {
case _SupabaseConfig():
return $default(_that.anonKey,_that.apiUrl,_that.dbUrl,_that.graphqlUrl,_that.inbucketUrl,_that.jwtSecret,_that.serviceRoleKey,_that.studioUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String anonKey,  String apiUrl,  String? dbUrl,  String? graphqlUrl,  String? inbucketUrl,  String? jwtSecret,  String? serviceRoleKey,  String? studioUrl)?  $default,) {final _that = this;
switch (_that) {
case _SupabaseConfig() when $default != null:
return $default(_that.anonKey,_that.apiUrl,_that.dbUrl,_that.graphqlUrl,_that.inbucketUrl,_that.jwtSecret,_that.serviceRoleKey,_that.studioUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.screamingSnake)
class _SupabaseConfig with DiagnosticableTreeMixin implements SupabaseConfig {
  const _SupabaseConfig({required this.anonKey, required this.apiUrl, this.dbUrl, this.graphqlUrl, this.inbucketUrl, this.jwtSecret, this.serviceRoleKey, this.studioUrl});
  factory _SupabaseConfig.fromJson(Map<String, dynamic> json) => _$SupabaseConfigFromJson(json);

@override final  String anonKey;
@override final  String apiUrl;
@override final  String? dbUrl;
@override final  String? graphqlUrl;
@override final  String? inbucketUrl;
@override final  String? jwtSecret;
@override final  String? serviceRoleKey;
@override final  String? studioUrl;

/// Create a copy of SupabaseConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupabaseConfigCopyWith<_SupabaseConfig> get copyWith => __$SupabaseConfigCopyWithImpl<_SupabaseConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupabaseConfigToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'SupabaseConfig'))
    ..add(DiagnosticsProperty('anonKey', anonKey))..add(DiagnosticsProperty('apiUrl', apiUrl))..add(DiagnosticsProperty('dbUrl', dbUrl))..add(DiagnosticsProperty('graphqlUrl', graphqlUrl))..add(DiagnosticsProperty('inbucketUrl', inbucketUrl))..add(DiagnosticsProperty('jwtSecret', jwtSecret))..add(DiagnosticsProperty('serviceRoleKey', serviceRoleKey))..add(DiagnosticsProperty('studioUrl', studioUrl));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupabaseConfig&&(identical(other.anonKey, anonKey) || other.anonKey == anonKey)&&(identical(other.apiUrl, apiUrl) || other.apiUrl == apiUrl)&&(identical(other.dbUrl, dbUrl) || other.dbUrl == dbUrl)&&(identical(other.graphqlUrl, graphqlUrl) || other.graphqlUrl == graphqlUrl)&&(identical(other.inbucketUrl, inbucketUrl) || other.inbucketUrl == inbucketUrl)&&(identical(other.jwtSecret, jwtSecret) || other.jwtSecret == jwtSecret)&&(identical(other.serviceRoleKey, serviceRoleKey) || other.serviceRoleKey == serviceRoleKey)&&(identical(other.studioUrl, studioUrl) || other.studioUrl == studioUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,anonKey,apiUrl,dbUrl,graphqlUrl,inbucketUrl,jwtSecret,serviceRoleKey,studioUrl);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'SupabaseConfig(anonKey: $anonKey, apiUrl: $apiUrl, dbUrl: $dbUrl, graphqlUrl: $graphqlUrl, inbucketUrl: $inbucketUrl, jwtSecret: $jwtSecret, serviceRoleKey: $serviceRoleKey, studioUrl: $studioUrl)';
}


}

/// @nodoc
abstract mixin class _$SupabaseConfigCopyWith<$Res> implements $SupabaseConfigCopyWith<$Res> {
  factory _$SupabaseConfigCopyWith(_SupabaseConfig value, $Res Function(_SupabaseConfig) _then) = __$SupabaseConfigCopyWithImpl;
@override @useResult
$Res call({
 String anonKey, String apiUrl, String? dbUrl, String? graphqlUrl, String? inbucketUrl, String? jwtSecret, String? serviceRoleKey, String? studioUrl
});




}
/// @nodoc
class __$SupabaseConfigCopyWithImpl<$Res>
    implements _$SupabaseConfigCopyWith<$Res> {
  __$SupabaseConfigCopyWithImpl(this._self, this._then);

  final _SupabaseConfig _self;
  final $Res Function(_SupabaseConfig) _then;

/// Create a copy of SupabaseConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anonKey = null,Object? apiUrl = null,Object? dbUrl = freezed,Object? graphqlUrl = freezed,Object? inbucketUrl = freezed,Object? jwtSecret = freezed,Object? serviceRoleKey = freezed,Object? studioUrl = freezed,}) {
  return _then(_SupabaseConfig(
anonKey: null == anonKey ? _self.anonKey : anonKey // ignore: cast_nullable_to_non_nullable
as String,apiUrl: null == apiUrl ? _self.apiUrl : apiUrl // ignore: cast_nullable_to_non_nullable
as String,dbUrl: freezed == dbUrl ? _self.dbUrl : dbUrl // ignore: cast_nullable_to_non_nullable
as String?,graphqlUrl: freezed == graphqlUrl ? _self.graphqlUrl : graphqlUrl // ignore: cast_nullable_to_non_nullable
as String?,inbucketUrl: freezed == inbucketUrl ? _self.inbucketUrl : inbucketUrl // ignore: cast_nullable_to_non_nullable
as String?,jwtSecret: freezed == jwtSecret ? _self.jwtSecret : jwtSecret // ignore: cast_nullable_to_non_nullable
as String?,serviceRoleKey: freezed == serviceRoleKey ? _self.serviceRoleKey : serviceRoleKey // ignore: cast_nullable_to_non_nullable
as String?,studioUrl: freezed == studioUrl ? _self.studioUrl : studioUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
