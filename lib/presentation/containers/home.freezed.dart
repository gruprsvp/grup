// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewModel implements DiagnosticableTreeMixin {

 bool get loading; Profile? get profile; Iterable<Group>? get groups; ValueSetter<GroupCreateResult>? get onGroupCreate; AsyncCallback? get onRefresh; bool? get shouldShowFeedback; VoidCallback? get onFeedbackDismiss;
/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewModelCopyWith<_ViewModel> get copyWith => __$ViewModelCopyWithImpl<_ViewModel>(this as _ViewModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', '_ViewModel'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('groups', groups))..add(DiagnosticsProperty('onGroupCreate', onGroupCreate))..add(DiagnosticsProperty('onRefresh', onRefresh))..add(DiagnosticsProperty('shouldShowFeedback', shouldShowFeedback))..add(DiagnosticsProperty('onFeedbackDismiss', onFeedbackDismiss));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.onGroupCreate, onGroupCreate) || other.onGroupCreate == onGroupCreate)&&(identical(other.onRefresh, onRefresh) || other.onRefresh == onRefresh)&&(identical(other.shouldShowFeedback, shouldShowFeedback) || other.shouldShowFeedback == shouldShowFeedback)&&(identical(other.onFeedbackDismiss, onFeedbackDismiss) || other.onFeedbackDismiss == onFeedbackDismiss));
}


@override
int get hashCode => Object.hash(runtimeType,loading,profile,const DeepCollectionEquality().hash(groups),onGroupCreate,onRefresh,shouldShowFeedback,onFeedbackDismiss);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return '_ViewModel(loading: $loading, profile: $profile, groups: $groups, onGroupCreate: $onGroupCreate, onRefresh: $onRefresh, shouldShowFeedback: $shouldShowFeedback, onFeedbackDismiss: $onFeedbackDismiss)';
}


}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res>  {
  factory _$ViewModelCopyWith(_ViewModel value, $Res Function(_ViewModel) _then) = __$ViewModelCopyWithImpl;
@useResult
$Res call({
 bool loading, Profile? profile, Iterable<Group>? groups, ValueSetter<GroupCreateResult>? onGroupCreate, AsyncCallback? onRefresh, bool? shouldShowFeedback, VoidCallback? onFeedbackDismiss
});


$ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ViewModelCopyWithImpl<$Res>
    implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._self, this._then);

  final _ViewModel _self;
  final $Res Function(_ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? profile = freezed,Object? groups = freezed,Object? onGroupCreate = freezed,Object? onRefresh = freezed,Object? shouldShowFeedback = freezed,Object? onFeedbackDismiss = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,groups: freezed == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as Iterable<Group>?,onGroupCreate: freezed == onGroupCreate ? _self.onGroupCreate : onGroupCreate // ignore: cast_nullable_to_non_nullable
as ValueSetter<GroupCreateResult>?,onRefresh: freezed == onRefresh ? _self.onRefresh : onRefresh // ignore: cast_nullable_to_non_nullable
as AsyncCallback?,shouldShowFeedback: freezed == shouldShowFeedback ? _self.shouldShowFeedback : shouldShowFeedback // ignore: cast_nullable_to_non_nullable
as bool?,onFeedbackDismiss: freezed == onFeedbackDismiss ? _self.onFeedbackDismiss : onFeedbackDismiss // ignore: cast_nullable_to_non_nullable
as VoidCallback?,
  ));
}
/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [_ViewModel].
extension _ViewModelPatterns on _ViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( __ViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( __ViewModel value)  $default,){
final _that = this;
switch (_that) {
case __ViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( __ViewModel value)?  $default,){
final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  Profile? profile,  Iterable<Group>? groups,  ValueSetter<GroupCreateResult>? onGroupCreate,  AsyncCallback? onRefresh,  bool? shouldShowFeedback,  VoidCallback? onFeedbackDismiss)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.profile,_that.groups,_that.onGroupCreate,_that.onRefresh,_that.shouldShowFeedback,_that.onFeedbackDismiss);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  Profile? profile,  Iterable<Group>? groups,  ValueSetter<GroupCreateResult>? onGroupCreate,  AsyncCallback? onRefresh,  bool? shouldShowFeedback,  VoidCallback? onFeedbackDismiss)  $default,) {final _that = this;
switch (_that) {
case __ViewModel():
return $default(_that.loading,_that.profile,_that.groups,_that.onGroupCreate,_that.onRefresh,_that.shouldShowFeedback,_that.onFeedbackDismiss);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  Profile? profile,  Iterable<Group>? groups,  ValueSetter<GroupCreateResult>? onGroupCreate,  AsyncCallback? onRefresh,  bool? shouldShowFeedback,  VoidCallback? onFeedbackDismiss)?  $default,) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.profile,_that.groups,_that.onGroupCreate,_that.onRefresh,_that.shouldShowFeedback,_that.onFeedbackDismiss);case _:
  return null;

}
}

}

/// @nodoc


class __ViewModel with DiagnosticableTreeMixin implements _ViewModel {
  const __ViewModel({required this.loading, this.profile, this.groups, this.onGroupCreate, this.onRefresh, this.shouldShowFeedback, this.onFeedbackDismiss});
  

@override final  bool loading;
@override final  Profile? profile;
@override final  Iterable<Group>? groups;
@override final  ValueSetter<GroupCreateResult>? onGroupCreate;
@override final  AsyncCallback? onRefresh;
@override final  bool? shouldShowFeedback;
@override final  VoidCallback? onFeedbackDismiss;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$_ViewModelCopyWith<__ViewModel> get copyWith => __$_ViewModelCopyWithImpl<__ViewModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', '_ViewModel'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('groups', groups))..add(DiagnosticsProperty('onGroupCreate', onGroupCreate))..add(DiagnosticsProperty('onRefresh', onRefresh))..add(DiagnosticsProperty('shouldShowFeedback', shouldShowFeedback))..add(DiagnosticsProperty('onFeedbackDismiss', onFeedbackDismiss));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is __ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.onGroupCreate, onGroupCreate) || other.onGroupCreate == onGroupCreate)&&(identical(other.onRefresh, onRefresh) || other.onRefresh == onRefresh)&&(identical(other.shouldShowFeedback, shouldShowFeedback) || other.shouldShowFeedback == shouldShowFeedback)&&(identical(other.onFeedbackDismiss, onFeedbackDismiss) || other.onFeedbackDismiss == onFeedbackDismiss));
}


@override
int get hashCode => Object.hash(runtimeType,loading,profile,const DeepCollectionEquality().hash(groups),onGroupCreate,onRefresh,shouldShowFeedback,onFeedbackDismiss);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return '_ViewModel(loading: $loading, profile: $profile, groups: $groups, onGroupCreate: $onGroupCreate, onRefresh: $onRefresh, shouldShowFeedback: $shouldShowFeedback, onFeedbackDismiss: $onFeedbackDismiss)';
}


}

/// @nodoc
abstract mixin class _$_ViewModelCopyWith<$Res> implements _$ViewModelCopyWith<$Res> {
  factory _$_ViewModelCopyWith(__ViewModel value, $Res Function(__ViewModel) _then) = __$_ViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool loading, Profile? profile, Iterable<Group>? groups, ValueSetter<GroupCreateResult>? onGroupCreate, AsyncCallback? onRefresh, bool? shouldShowFeedback, VoidCallback? onFeedbackDismiss
});


@override $ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$_ViewModelCopyWithImpl<$Res>
    implements _$_ViewModelCopyWith<$Res> {
  __$_ViewModelCopyWithImpl(this._self, this._then);

  final __ViewModel _self;
  final $Res Function(__ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? profile = freezed,Object? groups = freezed,Object? onGroupCreate = freezed,Object? onRefresh = freezed,Object? shouldShowFeedback = freezed,Object? onFeedbackDismiss = freezed,}) {
  return _then(__ViewModel(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,groups: freezed == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as Iterable<Group>?,onGroupCreate: freezed == onGroupCreate ? _self.onGroupCreate : onGroupCreate // ignore: cast_nullable_to_non_nullable
as ValueSetter<GroupCreateResult>?,onRefresh: freezed == onRefresh ? _self.onRefresh : onRefresh // ignore: cast_nullable_to_non_nullable
as AsyncCallback?,shouldShowFeedback: freezed == shouldShowFeedback ? _self.shouldShowFeedback : shouldShowFeedback // ignore: cast_nullable_to_non_nullable
as bool?,onFeedbackDismiss: freezed == onFeedbackDismiss ? _self.onFeedbackDismiss : onFeedbackDismiss // ignore: cast_nullable_to_non_nullable
as VoidCallback?,
  ));
}

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
