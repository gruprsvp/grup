// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_member_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ViewModel {
  bool get loading => throw _privateConstructorUsedError;
  bool get isCurrentUser => throw _privateConstructorUsedError;
  Group? get group => throw _privateConstructorUsedError;
  Member? get member => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  List<Invite>? get invites => throw _privateConstructorUsedError;
  ValueSetter<Member>? get onUpdate => throw _privateConstructorUsedError;
  OnRemoveFromGroupCallback? get onRemove => throw _privateConstructorUsedError;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$ViewModelCopyWith<_ViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$ViewModelCopyWith<$Res> {
  factory _$ViewModelCopyWith(
          _ViewModel value, $Res Function(_ViewModel) then) =
      __$ViewModelCopyWithImpl<$Res, _ViewModel>;
  @useResult
  $Res call(
      {bool loading,
      bool isCurrentUser,
      Group? group,
      Member? member,
      Profile? profile,
      List<Invite>? invites,
      ValueSetter<Member>? onUpdate,
      OnRemoveFromGroupCallback? onRemove});
}

/// @nodoc
class __$ViewModelCopyWithImpl<$Res, $Val extends _ViewModel>
    implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isCurrentUser = null,
    Object? group = freezed,
    Object? member = freezed,
    Object? profile = freezed,
    Object? invites = freezed,
    Object? onUpdate = freezed,
    Object? onRemove = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      member: freezed == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      invites: freezed == invites
          ? _value.invites
          : invites // ignore: cast_nullable_to_non_nullable
              as List<Invite>?,
      onUpdate: freezed == onUpdate
          ? _value.onUpdate
          : onUpdate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Member>?,
      onRemove: freezed == onRemove
          ? _value.onRemove
          : onRemove // ignore: cast_nullable_to_non_nullable
              as OnRemoveFromGroupCallback?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViewModelImplCopyWith<$Res>
    implements _$ViewModelCopyWith<$Res> {
  factory _$$_ViewModelImplCopyWith(
          _$_ViewModelImpl value, $Res Function(_$_ViewModelImpl) then) =
      __$$_ViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool isCurrentUser,
      Group? group,
      Member? member,
      Profile? profile,
      List<Invite>? invites,
      ValueSetter<Member>? onUpdate,
      OnRemoveFromGroupCallback? onRemove});
}

/// @nodoc
class __$$_ViewModelImplCopyWithImpl<$Res>
    extends __$ViewModelCopyWithImpl<$Res, _$_ViewModelImpl>
    implements _$$_ViewModelImplCopyWith<$Res> {
  __$$_ViewModelImplCopyWithImpl(
      _$_ViewModelImpl _value, $Res Function(_$_ViewModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? isCurrentUser = null,
    Object? group = freezed,
    Object? member = freezed,
    Object? profile = freezed,
    Object? invites = freezed,
    Object? onUpdate = freezed,
    Object? onRemove = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentUser: null == isCurrentUser
          ? _value.isCurrentUser
          : isCurrentUser // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      member: freezed == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      invites: freezed == invites
          ? _value._invites
          : invites // ignore: cast_nullable_to_non_nullable
              as List<Invite>?,
      onUpdate: freezed == onUpdate
          ? _value.onUpdate
          : onUpdate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Member>?,
      onRemove: freezed == onRemove
          ? _value.onRemove
          : onRemove // ignore: cast_nullable_to_non_nullable
              as OnRemoveFromGroupCallback?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.loading,
      required this.isCurrentUser,
      this.group,
      this.member,
      this.profile,
      final List<Invite>? invites,
      this.onUpdate,
      this.onRemove})
      : _invites = invites;

  @override
  final bool loading;
  @override
  final bool isCurrentUser;
  @override
  final Group? group;
  @override
  final Member? member;
  @override
  final Profile? profile;
  final List<Invite>? _invites;
  @override
  List<Invite>? get invites {
    final value = _invites;
    if (value == null) return null;
    if (_invites is EqualUnmodifiableListView) return _invites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ValueSetter<Member>? onUpdate;
  @override
  final OnRemoveFromGroupCallback? onRemove;

  @override
  String toString() {
    return '_ViewModel(loading: $loading, isCurrentUser: $isCurrentUser, group: $group, member: $member, profile: $profile, invites: $invites, onUpdate: $onUpdate, onRemove: $onRemove)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isCurrentUser, isCurrentUser) ||
                other.isCurrentUser == isCurrentUser) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other._invites, _invites) &&
            (identical(other.onUpdate, onUpdate) ||
                other.onUpdate == onUpdate) &&
            (identical(other.onRemove, onRemove) ||
                other.onRemove == onRemove));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      isCurrentUser,
      group,
      member,
      profile,
      const DeepCollectionEquality().hash(_invites),
      onUpdate,
      onRemove);

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      __$$_ViewModelImplCopyWithImpl<_$_ViewModelImpl>(this, _$identity);
}

abstract class __ViewModel implements _ViewModel {
  const factory __ViewModel(
      {required final bool loading,
      required final bool isCurrentUser,
      final Group? group,
      final Member? member,
      final Profile? profile,
      final List<Invite>? invites,
      final ValueSetter<Member>? onUpdate,
      final OnRemoveFromGroupCallback? onRemove}) = _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  bool get isCurrentUser;
  @override
  Group? get group;
  @override
  Member? get member;
  @override
  Profile? get profile;
  @override
  List<Invite>? get invites;
  @override
  ValueSetter<Member>? get onUpdate;
  @override
  OnRemoveFromGroupCallback? get onRemove;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
