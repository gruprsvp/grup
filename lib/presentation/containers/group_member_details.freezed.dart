// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ViewModel {

 bool get loading; bool get isCurrentUser; Group? get group; Member? get member; Profile? get profile; List<Invite>? get invites; ValueSetter<Member>? get onUpdate; OnRemoveFromGroupCallback? get onRemove;
/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViewModelCopyWith<_ViewModel> get copyWith => __$ViewModelCopyWithImpl<_ViewModel>(this as _ViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&(identical(other.group, group) || other.group == group)&&(identical(other.member, member) || other.member == member)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.invites, invites)&&(identical(other.onUpdate, onUpdate) || other.onUpdate == onUpdate)&&(identical(other.onRemove, onRemove) || other.onRemove == onRemove));
}


@override
int get hashCode => Object.hash(runtimeType,loading,isCurrentUser,group,member,profile,const DeepCollectionEquality().hash(invites),onUpdate,onRemove);

@override
String toString() {
  return '_ViewModel(loading: $loading, isCurrentUser: $isCurrentUser, group: $group, member: $member, profile: $profile, invites: $invites, onUpdate: $onUpdate, onRemove: $onRemove)';
}


}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res>  {
  factory _$ViewModelCopyWith(_ViewModel value, $Res Function(_ViewModel) _then) = __$ViewModelCopyWithImpl;
@useResult
$Res call({
 bool loading, bool isCurrentUser, Group? group, Member? member, Profile? profile, List<Invite>? invites, ValueSetter<Member>? onUpdate, OnRemoveFromGroupCallback? onRemove
});


$GroupCopyWith<$Res>? get group;$MemberCopyWith<$Res>? get member;$ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ViewModelCopyWithImpl<$Res>
    implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._self, this._then);

  final _ViewModel _self;
  final $Res Function(_ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? isCurrentUser = null,Object? group = freezed,Object? member = freezed,Object? profile = freezed,Object? invites = freezed,Object? onUpdate = freezed,Object? onRemove = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Member?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,invites: freezed == invites ? _self.invites : invites // ignore: cast_nullable_to_non_nullable
as List<Invite>?,onUpdate: freezed == onUpdate ? _self.onUpdate : onUpdate // ignore: cast_nullable_to_non_nullable
as ValueSetter<Member>?,onRemove: freezed == onRemove ? _self.onRemove : onRemove // ignore: cast_nullable_to_non_nullable
as OnRemoveFromGroupCallback?,
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
}/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberCopyWith<$Res>? get member {
    if (_self.member == null) {
    return null;
  }

  return $MemberCopyWith<$Res>(_self.member!, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of _ViewModel
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool isCurrentUser,  Group? group,  Member? member,  Profile? profile,  List<Invite>? invites,  ValueSetter<Member>? onUpdate,  OnRemoveFromGroupCallback? onRemove)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.isCurrentUser,_that.group,_that.member,_that.profile,_that.invites,_that.onUpdate,_that.onRemove);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool isCurrentUser,  Group? group,  Member? member,  Profile? profile,  List<Invite>? invites,  ValueSetter<Member>? onUpdate,  OnRemoveFromGroupCallback? onRemove)  $default,) {final _that = this;
switch (_that) {
case __ViewModel():
return $default(_that.loading,_that.isCurrentUser,_that.group,_that.member,_that.profile,_that.invites,_that.onUpdate,_that.onRemove);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool isCurrentUser,  Group? group,  Member? member,  Profile? profile,  List<Invite>? invites,  ValueSetter<Member>? onUpdate,  OnRemoveFromGroupCallback? onRemove)?  $default,) {final _that = this;
switch (_that) {
case __ViewModel() when $default != null:
return $default(_that.loading,_that.isCurrentUser,_that.group,_that.member,_that.profile,_that.invites,_that.onUpdate,_that.onRemove);case _:
  return null;

}
}

}

/// @nodoc


class __ViewModel implements _ViewModel {
  const __ViewModel({required this.loading, required this.isCurrentUser, this.group, this.member, this.profile, final  List<Invite>? invites, this.onUpdate, this.onRemove}): _invites = invites;
  

@override final  bool loading;
@override final  bool isCurrentUser;
@override final  Group? group;
@override final  Member? member;
@override final  Profile? profile;
 final  List<Invite>? _invites;
@override List<Invite>? get invites {
  final value = _invites;
  if (value == null) return null;
  if (_invites is EqualUnmodifiableListView) return _invites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ValueSetter<Member>? onUpdate;
@override final  OnRemoveFromGroupCallback? onRemove;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$_ViewModelCopyWith<__ViewModel> get copyWith => __$_ViewModelCopyWithImpl<__ViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is __ViewModel&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.isCurrentUser, isCurrentUser) || other.isCurrentUser == isCurrentUser)&&(identical(other.group, group) || other.group == group)&&(identical(other.member, member) || other.member == member)&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other._invites, _invites)&&(identical(other.onUpdate, onUpdate) || other.onUpdate == onUpdate)&&(identical(other.onRemove, onRemove) || other.onRemove == onRemove));
}


@override
int get hashCode => Object.hash(runtimeType,loading,isCurrentUser,group,member,profile,const DeepCollectionEquality().hash(_invites),onUpdate,onRemove);

@override
String toString() {
  return '_ViewModel(loading: $loading, isCurrentUser: $isCurrentUser, group: $group, member: $member, profile: $profile, invites: $invites, onUpdate: $onUpdate, onRemove: $onRemove)';
}


}

/// @nodoc
abstract mixin class _$_ViewModelCopyWith<$Res> implements _$ViewModelCopyWith<$Res> {
  factory _$_ViewModelCopyWith(__ViewModel value, $Res Function(__ViewModel) _then) = __$_ViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool isCurrentUser, Group? group, Member? member, Profile? profile, List<Invite>? invites, ValueSetter<Member>? onUpdate, OnRemoveFromGroupCallback? onRemove
});


@override $GroupCopyWith<$Res>? get group;@override $MemberCopyWith<$Res>? get member;@override $ProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$_ViewModelCopyWithImpl<$Res>
    implements _$_ViewModelCopyWith<$Res> {
  __$_ViewModelCopyWithImpl(this._self, this._then);

  final __ViewModel _self;
  final $Res Function(__ViewModel) _then;

/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? isCurrentUser = null,Object? group = freezed,Object? member = freezed,Object? profile = freezed,Object? invites = freezed,Object? onUpdate = freezed,Object? onRemove = freezed,}) {
  return _then(__ViewModel(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,isCurrentUser: null == isCurrentUser ? _self.isCurrentUser : isCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,member: freezed == member ? _self.member : member // ignore: cast_nullable_to_non_nullable
as Member?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile?,invites: freezed == invites ? _self._invites : invites // ignore: cast_nullable_to_non_nullable
as List<Invite>?,onUpdate: freezed == onUpdate ? _self.onUpdate : onUpdate // ignore: cast_nullable_to_non_nullable
as ValueSetter<Member>?,onRemove: freezed == onRemove ? _self.onRemove : onRemove // ignore: cast_nullable_to_non_nullable
as OnRemoveFromGroupCallback?,
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
}/// Create a copy of _ViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberCopyWith<$Res>? get member {
    if (_self.member == null) {
    return null;
  }

  return $MemberCopyWith<$Res>(_self.member!, (value) {
    return _then(_self.copyWith(member: value));
  });
}/// Create a copy of _ViewModel
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
