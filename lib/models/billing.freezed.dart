// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'billing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillingState implements DiagnosticableTreeMixin {

@JsonKey(unknownEnumValue: BillingMode.prelaunch) BillingMode get mode;/// The account was created before paid plans were announced.
 bool get isFounder;/// The user has paid on the web, so they have billing to manage.
 bool get isCustomer;/// The entitlements of each of the user's groups, by group id.
 Map<String, GroupEntitlements> get groups;/// The plans on sale, cheapest first.
 List<CatalogPlan> get catalog;
/// Create a copy of BillingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillingStateCopyWith<BillingState> get copyWith => _$BillingStateCopyWithImpl<BillingState>(this as BillingState, _$identity);

  /// Serializes this BillingState to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as BillingState;
  properties
    ..add(DiagnosticsProperty('type', 'BillingState'))
    ..add(DiagnosticsProperty('mode', _this.mode))..add(DiagnosticsProperty('isFounder', _this.isFounder))..add(DiagnosticsProperty('isCustomer', _this.isCustomer))..add(DiagnosticsProperty('groups', _this.groups))..add(DiagnosticsProperty('catalog', _this.catalog));
}

@override
bool operator ==(Object other) {
  final _this = this as BillingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillingState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.isFounder, _this.isFounder) || other.isFounder == _this.isFounder)&&(identical(other.isCustomer, _this.isCustomer) || other.isCustomer == _this.isCustomer)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.catalog, _this.catalog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BillingState;
  return Object.hash(runtimeType,_this.mode,_this.isFounder,_this.isCustomer,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.catalog));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as BillingState;
  return 'BillingState(mode: ${_this.mode}, isFounder: ${_this.isFounder}, isCustomer: ${_this.isCustomer}, groups: ${_this.groups}, catalog: ${_this.catalog})';
}


}

/// @nodoc
abstract mixin class $BillingStateCopyWith<$Res>  {
  factory $BillingStateCopyWith(BillingState value, $Res Function(BillingState) _then) = _$BillingStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: BillingMode.prelaunch) BillingMode mode, bool isFounder, bool isCustomer, Map<String, GroupEntitlements> groups, List<CatalogPlan> catalog
});




}
/// @nodoc
class _$BillingStateCopyWithImpl<$Res>
    implements $BillingStateCopyWith<$Res> {
  _$BillingStateCopyWithImpl(this._self, this._then);

  final BillingState _self;
  final $Res Function(BillingState) _then;

/// Create a copy of BillingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? isFounder = null,Object? isCustomer = null,Object? groups = null,Object? catalog = null,}) {
  return _then(BillingState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BillingMode,isFounder: null == isFounder ? _self.isFounder : isFounder // ignore: cast_nullable_to_non_nullable
as bool,isCustomer: null == isCustomer ? _self.isCustomer : isCustomer // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as Map<String, GroupEntitlements>,catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as List<CatalogPlan>,
  ));
}

}


/// Adds pattern-matching-related methods to [BillingState].
extension BillingStatePatterns on BillingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillingState value)  $default,){
final _that = this;
switch (_that) {
case _BillingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillingState value)?  $default,){
final _that = this;
switch (_that) {
case _BillingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: BillingMode.prelaunch)  BillingMode mode,  bool isFounder,  bool isCustomer,  Map<String, GroupEntitlements> groups,  List<CatalogPlan> catalog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillingState() when $default != null:
return $default(_that.mode,_that.isFounder,_that.isCustomer,_that.groups,_that.catalog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: BillingMode.prelaunch)  BillingMode mode,  bool isFounder,  bool isCustomer,  Map<String, GroupEntitlements> groups,  List<CatalogPlan> catalog)  $default,) {final _that = this;
switch (_that) {
case _BillingState():
return $default(_that.mode,_that.isFounder,_that.isCustomer,_that.groups,_that.catalog);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: BillingMode.prelaunch)  BillingMode mode,  bool isFounder,  bool isCustomer,  Map<String, GroupEntitlements> groups,  List<CatalogPlan> catalog)?  $default,) {final _that = this;
switch (_that) {
case _BillingState() when $default != null:
return $default(_that.mode,_that.isFounder,_that.isCustomer,_that.groups,_that.catalog);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BillingState with DiagnosticableTreeMixin implements BillingState {
  const _BillingState({@JsonKey(unknownEnumValue: BillingMode.prelaunch) this.mode = BillingMode.prelaunch, this.isFounder = false, this.isCustomer = false,  Map<String, GroupEntitlements> groups = const {},  List<CatalogPlan> catalog = const []}): _groups = groups,_catalog = catalog;
  factory _BillingState.fromJson(Map<String, dynamic> json) => _$BillingStateFromJson(json);

@override@JsonKey(unknownEnumValue: BillingMode.prelaunch) final  BillingMode mode;
/// The account was created before paid plans were announced.
@override@JsonKey() final  bool isFounder;
/// The user has paid on the web, so they have billing to manage.
@override@JsonKey() final  bool isCustomer;
/// The entitlements of each of the user's groups, by group id.
 final  Map<String, GroupEntitlements> _groups;
/// The entitlements of each of the user's groups, by group id.
@override@JsonKey() Map<String, GroupEntitlements> get groups {
  if (_groups is EqualUnmodifiableMapView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_groups);
}

/// The plans on sale, cheapest first.
 final  List<CatalogPlan> _catalog;
/// The plans on sale, cheapest first.
@override@JsonKey() List<CatalogPlan> get catalog {
  if (_catalog is EqualUnmodifiableListView) return _catalog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_catalog);
}


/// Create a copy of BillingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillingStateCopyWith<_BillingState> get copyWith => __$BillingStateCopyWithImpl<_BillingState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillingStateToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'BillingState'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('isFounder', isFounder))..add(DiagnosticsProperty('isCustomer', isCustomer))..add(DiagnosticsProperty('groups', groups))..add(DiagnosticsProperty('catalog', catalog));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillingState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isFounder, isFounder) || other.isFounder == isFounder)&&(identical(other.isCustomer, isCustomer) || other.isCustomer == isCustomer)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.catalog, _catalog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,mode,isFounder,isCustomer,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_catalog));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'BillingState(mode: $mode, isFounder: $isFounder, isCustomer: $isCustomer, groups: $groups, catalog: $catalog)';
}


}

/// @nodoc
abstract mixin class _$BillingStateCopyWith<$Res> implements $BillingStateCopyWith<$Res> {
  factory _$BillingStateCopyWith(_BillingState value, $Res Function(_BillingState) _then) = __$BillingStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: BillingMode.prelaunch) BillingMode mode, bool isFounder, bool isCustomer, Map<String, GroupEntitlements> groups, List<CatalogPlan> catalog
});




}
/// @nodoc
class __$BillingStateCopyWithImpl<$Res>
    implements _$BillingStateCopyWith<$Res> {
  __$BillingStateCopyWithImpl(this._self, this._then);

  final _BillingState _self;
  final $Res Function(_BillingState) _then;

/// Create a copy of BillingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? isFounder = null,Object? isCustomer = null,Object? groups = null,Object? catalog = null,}) {
  return _then(_BillingState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BillingMode,isFounder: null == isFounder ? _self.isFounder : isFounder // ignore: cast_nullable_to_non_nullable
as bool,isCustomer: null == isCustomer ? _self.isCustomer : isCustomer // ignore: cast_nullable_to_non_nullable
as bool,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as Map<String, GroupEntitlements>,catalog: null == catalog ? _self._catalog : catalog // ignore: cast_nullable_to_non_nullable
as List<CatalogPlan>,
  ));
}


}


/// @nodoc
mixin _$GroupEntitlements implements DiagnosticableTreeMixin {

 List<String> get features;/// A limit that is null, or missing, is unlimited.
 Map<String, int?> get limits;/// Members with an account, plus members with a pending invite.
 int get seats; List<EntitlementSource> get sources;
/// Create a copy of GroupEntitlements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroupEntitlementsCopyWith<GroupEntitlements> get copyWith => _$GroupEntitlementsCopyWithImpl<GroupEntitlements>(this as GroupEntitlements, _$identity);

  /// Serializes this GroupEntitlements to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as GroupEntitlements;
  properties
    ..add(DiagnosticsProperty('type', 'GroupEntitlements'))
    ..add(DiagnosticsProperty('features', _this.features))..add(DiagnosticsProperty('limits', _this.limits))..add(DiagnosticsProperty('seats', _this.seats))..add(DiagnosticsProperty('sources', _this.sources));
}

@override
bool operator ==(Object other) {
  final _this = this as GroupEntitlements;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroupEntitlements&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.limits, _this.limits)&&(identical(other.seats, _this.seats) || other.seats == _this.seats)&&const DeepCollectionEquality().equals(other.sources, _this.sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GroupEntitlements;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.limits),_this.seats,const DeepCollectionEquality().hash(_this.sources));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as GroupEntitlements;
  return 'GroupEntitlements(features: ${_this.features}, limits: ${_this.limits}, seats: ${_this.seats}, sources: ${_this.sources})';
}


}

/// @nodoc
abstract mixin class $GroupEntitlementsCopyWith<$Res>  {
  factory $GroupEntitlementsCopyWith(GroupEntitlements value, $Res Function(GroupEntitlements) _then) = _$GroupEntitlementsCopyWithImpl;
@useResult
$Res call({
 List<String> features, Map<String, int?> limits, int seats, List<EntitlementSource> sources
});




}
/// @nodoc
class _$GroupEntitlementsCopyWithImpl<$Res>
    implements $GroupEntitlementsCopyWith<$Res> {
  _$GroupEntitlementsCopyWithImpl(this._self, this._then);

  final GroupEntitlements _self;
  final $Res Function(GroupEntitlements) _then;

/// Create a copy of GroupEntitlements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? features = null,Object? limits = null,Object? seats = null,Object? sources = null,}) {
  return _then(GroupEntitlements(
features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<EntitlementSource>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroupEntitlements].
extension GroupEntitlementsPatterns on GroupEntitlements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroupEntitlements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroupEntitlements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroupEntitlements value)  $default,){
final _that = this;
switch (_that) {
case _GroupEntitlements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroupEntitlements value)?  $default,){
final _that = this;
switch (_that) {
case _GroupEntitlements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> features,  Map<String, int?> limits,  int seats,  List<EntitlementSource> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroupEntitlements() when $default != null:
return $default(_that.features,_that.limits,_that.seats,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> features,  Map<String, int?> limits,  int seats,  List<EntitlementSource> sources)  $default,) {final _that = this;
switch (_that) {
case _GroupEntitlements():
return $default(_that.features,_that.limits,_that.seats,_that.sources);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> features,  Map<String, int?> limits,  int seats,  List<EntitlementSource> sources)?  $default,) {final _that = this;
switch (_that) {
case _GroupEntitlements() when $default != null:
return $default(_that.features,_that.limits,_that.seats,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GroupEntitlements with DiagnosticableTreeMixin implements GroupEntitlements {
  const _GroupEntitlements({ List<String> features = const [],  Map<String, int?> limits = const {}, this.seats = 0,  List<EntitlementSource> sources = const []}): _features = features,_limits = limits,_sources = sources;
  factory _GroupEntitlements.fromJson(Map<String, dynamic> json) => _$GroupEntitlementsFromJson(json);

 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

/// A limit that is null, or missing, is unlimited.
 final  Map<String, int?> _limits;
/// A limit that is null, or missing, is unlimited.
@override@JsonKey() Map<String, int?> get limits {
  if (_limits is EqualUnmodifiableMapView) return _limits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_limits);
}

/// Members with an account, plus members with a pending invite.
@override@JsonKey() final  int seats;
 final  List<EntitlementSource> _sources;
@override@JsonKey() List<EntitlementSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of GroupEntitlements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroupEntitlementsCopyWith<_GroupEntitlements> get copyWith => __$GroupEntitlementsCopyWithImpl<_GroupEntitlements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroupEntitlementsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'GroupEntitlements'))
    ..add(DiagnosticsProperty('features', features))..add(DiagnosticsProperty('limits', limits))..add(DiagnosticsProperty('seats', seats))..add(DiagnosticsProperty('sources', sources));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroupEntitlements&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.limits, _limits)&&(identical(other.seats, seats) || other.seats == seats)&&const DeepCollectionEquality().equals(other.sources, _sources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_limits),seats,const DeepCollectionEquality().hash(_sources));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'GroupEntitlements(features: $features, limits: $limits, seats: $seats, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$GroupEntitlementsCopyWith<$Res> implements $GroupEntitlementsCopyWith<$Res> {
  factory _$GroupEntitlementsCopyWith(_GroupEntitlements value, $Res Function(_GroupEntitlements) _then) = __$GroupEntitlementsCopyWithImpl;
@override @useResult
$Res call({
 List<String> features, Map<String, int?> limits, int seats, List<EntitlementSource> sources
});




}
/// @nodoc
class __$GroupEntitlementsCopyWithImpl<$Res>
    implements _$GroupEntitlementsCopyWith<$Res> {
  __$GroupEntitlementsCopyWithImpl(this._self, this._then);

  final _GroupEntitlements _self;
  final $Res Function(_GroupEntitlements) _then;

/// Create a copy of GroupEntitlements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? features = null,Object? limits = null,Object? seats = null,Object? sources = null,}) {
  return _then(_GroupEntitlements(
features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,limits: null == limits ? _self._limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as int,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<EntitlementSource>,
  ));
}


}


/// @nodoc
mixin _$EntitlementSource implements DiagnosticableTreeMixin {

/// `grant` or `subscription`.
 String get kind;/// A grant's source: `legacy`, `founder_trial`, `early_access`, `manual`.
 String? get source;/// A subscription's plan and its rank among plans.
 String? get plan; int? get rank;/// A subscription's provider (`stripe`, `app_store`, ...) and status.
 String? get provider; String? get status;/// The user id of who pays for the subscription.
 String? get payer;/// When it ends (a subscription: renews); `null` for never.
 DateTime? get until;/// Whether a subscription renews at [until].
 bool? get renews;
/// Create a copy of EntitlementSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntitlementSourceCopyWith<EntitlementSource> get copyWith => _$EntitlementSourceCopyWithImpl<EntitlementSource>(this as EntitlementSource, _$identity);

  /// Serializes this EntitlementSource to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as EntitlementSource;
  properties
    ..add(DiagnosticsProperty('type', 'EntitlementSource'))
    ..add(DiagnosticsProperty('kind', _this.kind))..add(DiagnosticsProperty('source', _this.source))..add(DiagnosticsProperty('plan', _this.plan))..add(DiagnosticsProperty('rank', _this.rank))..add(DiagnosticsProperty('provider', _this.provider))..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('payer', _this.payer))..add(DiagnosticsProperty('until', _this.until))..add(DiagnosticsProperty('renews', _this.renews));
}

@override
bool operator ==(Object other) {
  final _this = this as EntitlementSource;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntitlementSource&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.payer, _this.payer) || other.payer == _this.payer)&&(identical(other.until, _this.until) || other.until == _this.until)&&(identical(other.renews, _this.renews) || other.renews == _this.renews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EntitlementSource;
  return Object.hash(runtimeType,_this.kind,_this.source,_this.plan,_this.rank,_this.provider,_this.status,_this.payer,_this.until,_this.renews);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as EntitlementSource;
  return 'EntitlementSource(kind: ${_this.kind}, source: ${_this.source}, plan: ${_this.plan}, rank: ${_this.rank}, provider: ${_this.provider}, status: ${_this.status}, payer: ${_this.payer}, until: ${_this.until}, renews: ${_this.renews})';
}


}

/// @nodoc
abstract mixin class $EntitlementSourceCopyWith<$Res>  {
  factory $EntitlementSourceCopyWith(EntitlementSource value, $Res Function(EntitlementSource) _then) = _$EntitlementSourceCopyWithImpl;
@useResult
$Res call({
 String kind, String? source, String? plan, int? rank, String? provider, String? status, String? payer, DateTime? until, bool? renews
});




}
/// @nodoc
class _$EntitlementSourceCopyWithImpl<$Res>
    implements $EntitlementSourceCopyWith<$Res> {
  _$EntitlementSourceCopyWithImpl(this._self, this._then);

  final EntitlementSource _self;
  final $Res Function(EntitlementSource) _then;

/// Create a copy of EntitlementSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? source = freezed,Object? plan = freezed,Object? rank = freezed,Object? provider = freezed,Object? status = freezed,Object? payer = freezed,Object? until = freezed,Object? renews = freezed,}) {
  return _then(EntitlementSource(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String?,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,payer: freezed == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as String?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,renews: freezed == renews ? _self.renews : renews // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [EntitlementSource].
extension EntitlementSourcePatterns on EntitlementSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntitlementSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntitlementSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntitlementSource value)  $default,){
final _that = this;
switch (_that) {
case _EntitlementSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntitlementSource value)?  $default,){
final _that = this;
switch (_that) {
case _EntitlementSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  String? source,  String? plan,  int? rank,  String? provider,  String? status,  String? payer,  DateTime? until,  bool? renews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntitlementSource() when $default != null:
return $default(_that.kind,_that.source,_that.plan,_that.rank,_that.provider,_that.status,_that.payer,_that.until,_that.renews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  String? source,  String? plan,  int? rank,  String? provider,  String? status,  String? payer,  DateTime? until,  bool? renews)  $default,) {final _that = this;
switch (_that) {
case _EntitlementSource():
return $default(_that.kind,_that.source,_that.plan,_that.rank,_that.provider,_that.status,_that.payer,_that.until,_that.renews);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  String? source,  String? plan,  int? rank,  String? provider,  String? status,  String? payer,  DateTime? until,  bool? renews)?  $default,) {final _that = this;
switch (_that) {
case _EntitlementSource() when $default != null:
return $default(_that.kind,_that.source,_that.plan,_that.rank,_that.provider,_that.status,_that.payer,_that.until,_that.renews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntitlementSource with DiagnosticableTreeMixin implements EntitlementSource {
  const _EntitlementSource({required this.kind, this.source, this.plan, this.rank, this.provider, this.status, this.payer, this.until, this.renews});
  factory _EntitlementSource.fromJson(Map<String, dynamic> json) => _$EntitlementSourceFromJson(json);

/// `grant` or `subscription`.
@override final  String kind;
/// A grant's source: `legacy`, `founder_trial`, `early_access`, `manual`.
@override final  String? source;
/// A subscription's plan and its rank among plans.
@override final  String? plan;
@override final  int? rank;
/// A subscription's provider (`stripe`, `app_store`, ...) and status.
@override final  String? provider;
@override final  String? status;
/// The user id of who pays for the subscription.
@override final  String? payer;
/// When it ends (a subscription: renews); `null` for never.
@override final  DateTime? until;
/// Whether a subscription renews at [until].
@override final  bool? renews;

/// Create a copy of EntitlementSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntitlementSourceCopyWith<_EntitlementSource> get copyWith => __$EntitlementSourceCopyWithImpl<_EntitlementSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntitlementSourceToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'EntitlementSource'))
    ..add(DiagnosticsProperty('kind', kind))..add(DiagnosticsProperty('source', source))..add(DiagnosticsProperty('plan', plan))..add(DiagnosticsProperty('rank', rank))..add(DiagnosticsProperty('provider', provider))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('payer', payer))..add(DiagnosticsProperty('until', until))..add(DiagnosticsProperty('renews', renews));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntitlementSource&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.source, source) || other.source == source)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.status, status) || other.status == status)&&(identical(other.payer, payer) || other.payer == payer)&&(identical(other.until, until) || other.until == until)&&(identical(other.renews, renews) || other.renews == renews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kind,source,plan,rank,provider,status,payer,until,renews);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'EntitlementSource(kind: $kind, source: $source, plan: $plan, rank: $rank, provider: $provider, status: $status, payer: $payer, until: $until, renews: $renews)';
}


}

/// @nodoc
abstract mixin class _$EntitlementSourceCopyWith<$Res> implements $EntitlementSourceCopyWith<$Res> {
  factory _$EntitlementSourceCopyWith(_EntitlementSource value, $Res Function(_EntitlementSource) _then) = __$EntitlementSourceCopyWithImpl;
@override @useResult
$Res call({
 String kind, String? source, String? plan, int? rank, String? provider, String? status, String? payer, DateTime? until, bool? renews
});




}
/// @nodoc
class __$EntitlementSourceCopyWithImpl<$Res>
    implements _$EntitlementSourceCopyWith<$Res> {
  __$EntitlementSourceCopyWithImpl(this._self, this._then);

  final _EntitlementSource _self;
  final $Res Function(_EntitlementSource) _then;

/// Create a copy of EntitlementSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? source = freezed,Object? plan = freezed,Object? rank = freezed,Object? provider = freezed,Object? status = freezed,Object? payer = freezed,Object? until = freezed,Object? renews = freezed,}) {
  return _then(_EntitlementSource(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,plan: freezed == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String?,rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,payer: freezed == payer ? _self.payer : payer // ignore: cast_nullable_to_non_nullable
as String?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,renews: freezed == renews ? _self.renews : renews // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$CatalogPlan implements DiagnosticableTreeMixin {

 String get plan; int get rank; List<String> get features; Map<String, int?> get limits; List<CatalogPrice> get prices;
/// Create a copy of CatalogPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogPlanCopyWith<CatalogPlan> get copyWith => _$CatalogPlanCopyWithImpl<CatalogPlan>(this as CatalogPlan, _$identity);

  /// Serializes this CatalogPlan to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as CatalogPlan;
  properties
    ..add(DiagnosticsProperty('type', 'CatalogPlan'))
    ..add(DiagnosticsProperty('plan', _this.plan))..add(DiagnosticsProperty('rank', _this.rank))..add(DiagnosticsProperty('features', _this.features))..add(DiagnosticsProperty('limits', _this.limits))..add(DiagnosticsProperty('prices', _this.prices));
}

@override
bool operator ==(Object other) {
  final _this = this as CatalogPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogPlan&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&const DeepCollectionEquality().equals(other.features, _this.features)&&const DeepCollectionEquality().equals(other.limits, _this.limits)&&const DeepCollectionEquality().equals(other.prices, _this.prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogPlan;
  return Object.hash(runtimeType,_this.plan,_this.rank,const DeepCollectionEquality().hash(_this.features),const DeepCollectionEquality().hash(_this.limits),const DeepCollectionEquality().hash(_this.prices));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as CatalogPlan;
  return 'CatalogPlan(plan: ${_this.plan}, rank: ${_this.rank}, features: ${_this.features}, limits: ${_this.limits}, prices: ${_this.prices})';
}


}

/// @nodoc
abstract mixin class $CatalogPlanCopyWith<$Res>  {
  factory $CatalogPlanCopyWith(CatalogPlan value, $Res Function(CatalogPlan) _then) = _$CatalogPlanCopyWithImpl;
@useResult
$Res call({
 String plan, int rank, List<String> features, Map<String, int?> limits, List<CatalogPrice> prices
});




}
/// @nodoc
class _$CatalogPlanCopyWithImpl<$Res>
    implements $CatalogPlanCopyWith<$Res> {
  _$CatalogPlanCopyWithImpl(this._self, this._then);

  final CatalogPlan _self;
  final $Res Function(CatalogPlan) _then;

/// Create a copy of CatalogPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? rank = null,Object? features = null,Object? limits = null,Object? prices = null,}) {
  return _then(CatalogPlan(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as List<String>,limits: null == limits ? _self.limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<CatalogPrice>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogPlan].
extension CatalogPlanPatterns on CatalogPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogPlan value)  $default,){
final _that = this;
switch (_that) {
case _CatalogPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogPlan value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String plan,  int rank,  List<String> features,  Map<String, int?> limits,  List<CatalogPrice> prices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogPlan() when $default != null:
return $default(_that.plan,_that.rank,_that.features,_that.limits,_that.prices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String plan,  int rank,  List<String> features,  Map<String, int?> limits,  List<CatalogPrice> prices)  $default,) {final _that = this;
switch (_that) {
case _CatalogPlan():
return $default(_that.plan,_that.rank,_that.features,_that.limits,_that.prices);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String plan,  int rank,  List<String> features,  Map<String, int?> limits,  List<CatalogPrice> prices)?  $default,) {final _that = this;
switch (_that) {
case _CatalogPlan() when $default != null:
return $default(_that.plan,_that.rank,_that.features,_that.limits,_that.prices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogPlan with DiagnosticableTreeMixin implements CatalogPlan {
  const _CatalogPlan({required this.plan, required this.rank,  List<String> features = const [],  Map<String, int?> limits = const {},  List<CatalogPrice> prices = const []}): _features = features,_limits = limits,_prices = prices;
  factory _CatalogPlan.fromJson(Map<String, dynamic> json) => _$CatalogPlanFromJson(json);

@override final  String plan;
@override final  int rank;
 final  List<String> _features;
@override@JsonKey() List<String> get features {
  if (_features is EqualUnmodifiableListView) return _features;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_features);
}

 final  Map<String, int?> _limits;
@override@JsonKey() Map<String, int?> get limits {
  if (_limits is EqualUnmodifiableMapView) return _limits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_limits);
}

 final  List<CatalogPrice> _prices;
@override@JsonKey() List<CatalogPrice> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}


/// Create a copy of CatalogPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogPlanCopyWith<_CatalogPlan> get copyWith => __$CatalogPlanCopyWithImpl<_CatalogPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogPlanToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'CatalogPlan'))
    ..add(DiagnosticsProperty('plan', plan))..add(DiagnosticsProperty('rank', rank))..add(DiagnosticsProperty('features', features))..add(DiagnosticsProperty('limits', limits))..add(DiagnosticsProperty('prices', prices));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogPlan&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.rank, rank) || other.rank == rank)&&const DeepCollectionEquality().equals(other.features, _features)&&const DeepCollectionEquality().equals(other.limits, _limits)&&const DeepCollectionEquality().equals(other.prices, _prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plan,rank,const DeepCollectionEquality().hash(_features),const DeepCollectionEquality().hash(_limits),const DeepCollectionEquality().hash(_prices));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'CatalogPlan(plan: $plan, rank: $rank, features: $features, limits: $limits, prices: $prices)';
}


}

/// @nodoc
abstract mixin class _$CatalogPlanCopyWith<$Res> implements $CatalogPlanCopyWith<$Res> {
  factory _$CatalogPlanCopyWith(_CatalogPlan value, $Res Function(_CatalogPlan) _then) = __$CatalogPlanCopyWithImpl;
@override @useResult
$Res call({
 String plan, int rank, List<String> features, Map<String, int?> limits, List<CatalogPrice> prices
});




}
/// @nodoc
class __$CatalogPlanCopyWithImpl<$Res>
    implements _$CatalogPlanCopyWith<$Res> {
  __$CatalogPlanCopyWithImpl(this._self, this._then);

  final _CatalogPlan _self;
  final $Res Function(_CatalogPlan) _then;

/// Create a copy of CatalogPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? rank = null,Object? features = null,Object? limits = null,Object? prices = null,}) {
  return _then(_CatalogPlan(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,features: null == features ? _self._features : features // ignore: cast_nullable_to_non_nullable
as List<String>,limits: null == limits ? _self._limits : limits // ignore: cast_nullable_to_non_nullable
as Map<String, int?>,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<CatalogPrice>,
  ));
}


}


/// @nodoc
mixin _$CatalogPrice implements DiagnosticableTreeMixin {

 String get provider; String get id;/// `month` or `year`.
 String get interval;/// For display only, in minor units by currency: `{"CHF": 900}`.
 Map<String, int> get amounts;
/// Create a copy of CatalogPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogPriceCopyWith<CatalogPrice> get copyWith => _$CatalogPriceCopyWithImpl<CatalogPrice>(this as CatalogPrice, _$identity);

  /// Serializes this CatalogPrice to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as CatalogPrice;
  properties
    ..add(DiagnosticsProperty('type', 'CatalogPrice'))
    ..add(DiagnosticsProperty('provider', _this.provider))..add(DiagnosticsProperty('id', _this.id))..add(DiagnosticsProperty('interval', _this.interval))..add(DiagnosticsProperty('amounts', _this.amounts));
}

@override
bool operator ==(Object other) {
  final _this = this as CatalogPrice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogPrice&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&const DeepCollectionEquality().equals(other.amounts, _this.amounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CatalogPrice;
  return Object.hash(runtimeType,_this.provider,_this.id,_this.interval,const DeepCollectionEquality().hash(_this.amounts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as CatalogPrice;
  return 'CatalogPrice(provider: ${_this.provider}, id: ${_this.id}, interval: ${_this.interval}, amounts: ${_this.amounts})';
}


}

/// @nodoc
abstract mixin class $CatalogPriceCopyWith<$Res>  {
  factory $CatalogPriceCopyWith(CatalogPrice value, $Res Function(CatalogPrice) _then) = _$CatalogPriceCopyWithImpl;
@useResult
$Res call({
 String provider, String id, String interval, Map<String, int> amounts
});




}
/// @nodoc
class _$CatalogPriceCopyWithImpl<$Res>
    implements $CatalogPriceCopyWith<$Res> {
  _$CatalogPriceCopyWithImpl(this._self, this._then);

  final CatalogPrice _self;
  final $Res Function(CatalogPrice) _then;

/// Create a copy of CatalogPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? id = null,Object? interval = null,Object? amounts = null,}) {
  return _then(CatalogPrice(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,amounts: null == amounts ? _self.amounts : amounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogPrice].
extension CatalogPricePatterns on CatalogPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogPrice value)  $default,){
final _that = this;
switch (_that) {
case _CatalogPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogPrice value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String id,  String interval,  Map<String, int> amounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogPrice() when $default != null:
return $default(_that.provider,_that.id,_that.interval,_that.amounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String id,  String interval,  Map<String, int> amounts)  $default,) {final _that = this;
switch (_that) {
case _CatalogPrice():
return $default(_that.provider,_that.id,_that.interval,_that.amounts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String id,  String interval,  Map<String, int> amounts)?  $default,) {final _that = this;
switch (_that) {
case _CatalogPrice() when $default != null:
return $default(_that.provider,_that.id,_that.interval,_that.amounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogPrice with DiagnosticableTreeMixin implements CatalogPrice {
  const _CatalogPrice({required this.provider, required this.id, required this.interval,  Map<String, int> amounts = const {}}): _amounts = amounts;
  factory _CatalogPrice.fromJson(Map<String, dynamic> json) => _$CatalogPriceFromJson(json);

@override final  String provider;
@override final  String id;
/// `month` or `year`.
@override final  String interval;
/// For display only, in minor units by currency: `{"CHF": 900}`.
 final  Map<String, int> _amounts;
/// For display only, in minor units by currency: `{"CHF": 900}`.
@override@JsonKey() Map<String, int> get amounts {
  if (_amounts is EqualUnmodifiableMapView) return _amounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_amounts);
}


/// Create a copy of CatalogPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogPriceCopyWith<_CatalogPrice> get copyWith => __$CatalogPriceCopyWithImpl<_CatalogPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogPriceToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'CatalogPrice'))
    ..add(DiagnosticsProperty('provider', provider))..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('interval', interval))..add(DiagnosticsProperty('amounts', amounts));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogPrice&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.id, id) || other.id == id)&&(identical(other.interval, interval) || other.interval == interval)&&const DeepCollectionEquality().equals(other.amounts, _amounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,provider,id,interval,const DeepCollectionEquality().hash(_amounts));
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'CatalogPrice(provider: $provider, id: $id, interval: $interval, amounts: $amounts)';
}


}

/// @nodoc
abstract mixin class _$CatalogPriceCopyWith<$Res> implements $CatalogPriceCopyWith<$Res> {
  factory _$CatalogPriceCopyWith(_CatalogPrice value, $Res Function(_CatalogPrice) _then) = __$CatalogPriceCopyWithImpl;
@override @useResult
$Res call({
 String provider, String id, String interval, Map<String, int> amounts
});




}
/// @nodoc
class __$CatalogPriceCopyWithImpl<$Res>
    implements _$CatalogPriceCopyWith<$Res> {
  __$CatalogPriceCopyWithImpl(this._self, this._then);

  final _CatalogPrice _self;
  final $Res Function(_CatalogPrice) _then;

/// Create a copy of CatalogPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? id = null,Object? interval = null,Object? amounts = null,}) {
  return _then(_CatalogPrice(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as String,amounts: null == amounts ? _self._amounts : amounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
