// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewModel implements DiagnosticableTreeMixin {

 bool get loading; bool get isAdmin; Group? get group;
/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewModelCopyWith<_ViewModel> get copyWith => __$ViewModelCopyWithImpl<_ViewModel>(this as _ViewModel, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', '_ViewModel'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('isAdmin', isAdmin))..add(DiagnosticsProperty('group', group));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode => Object.hash(runtimeType,loading,isAdmin,group);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return '_ViewModel(loading: $loading, isAdmin: $isAdmin, group: $group)';
}


}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res>  {
  factory _$ViewModelCopyWith(_ViewModel value, $Res Function(_ViewModel) _then) = __$ViewModelCopyWithImpl;
@useResult
$Res call({
 bool loading, bool isAdmin, Group? group
});


$GroupCopyWith<$Res>? get group;

}
/// @nodoc
class __$ViewModelCopyWithImpl<$Res>
    implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._self, this._then);

  final _ViewModel _self;
  final $Res Function(_ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? isAdmin = null,Object? group = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,
  ));
}
/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool isAdmin,  Group? group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.isAdmin,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool isAdmin,  Group? group)  $default,) {final _that = this;
switch (_that) {
case __ViewModel():
return $default(_that.loading,_that.isAdmin,_that.group);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool isAdmin,  Group? group)?  $default,) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.isAdmin,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class __ViewModel with DiagnosticableTreeMixin implements _ViewModel {
  const __ViewModel({required this.loading, required this.isAdmin, this.group});
  

@override final  bool loading;
@override final  bool isAdmin;
@override final  Group? group;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$_ViewModelCopyWith<__ViewModel> get copyWith => __$_ViewModelCopyWithImpl<__ViewModel>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', '_ViewModel'))
    ..add(DiagnosticsProperty('loading', loading))..add(DiagnosticsProperty('isAdmin', isAdmin))..add(DiagnosticsProperty('group', group));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is __ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode => Object.hash(runtimeType,loading,isAdmin,group);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return '_ViewModel(loading: $loading, isAdmin: $isAdmin, group: $group)';
}


}

/// @nodoc
abstract mixin class _$_ViewModelCopyWith<$Res> implements _$ViewModelCopyWith<$Res> {
  factory _$_ViewModelCopyWith(__ViewModel value, $Res Function(__ViewModel) _then) = __$_ViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool isAdmin, Group? group
});


@override $GroupCopyWith<$Res>? get group;

}
/// @nodoc
class __$_ViewModelCopyWithImpl<$Res>
    implements _$_ViewModelCopyWith<$Res> {
  __$_ViewModelCopyWithImpl(this._self, this._then);

  final __ViewModel _self;
  final $Res Function(__ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? isAdmin = null,Object? group = freezed,}) {
  return _then(__ViewModel(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,
  ));
}

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}
}

// dart format on
