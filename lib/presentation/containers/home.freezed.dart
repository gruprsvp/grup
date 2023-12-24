// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ViewModel {
  bool get loading => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;
  Iterable<Group>? get groups => throw _privateConstructorUsedError;
  ValueSetter<GroupCreateResult>? get onGroupCreate =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
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
      Profile? profile,
      Iterable<Group>? groups,
      ValueSetter<GroupCreateResult>? onGroupCreate});

  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$ViewModelCopyWithImpl<$Res, $Val extends _ViewModel>
    implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? profile = freezed,
    Object? groups = freezed,
    Object? onGroupCreate = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as Iterable<Group>?,
      onGroupCreate: freezed == onGroupCreate
          ? _value.onGroupCreate
          : onGroupCreate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<GroupCreateResult>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
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
      Profile? profile,
      Iterable<Group>? groups,
      ValueSetter<GroupCreateResult>? onGroupCreate});

  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$_ViewModelImplCopyWithImpl<$Res>
    extends __$ViewModelCopyWithImpl<$Res, _$_ViewModelImpl>
    implements _$$_ViewModelImplCopyWith<$Res> {
  __$$_ViewModelImplCopyWithImpl(
      _$_ViewModelImpl _value, $Res Function(_$_ViewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? profile = freezed,
    Object? groups = freezed,
    Object? onGroupCreate = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as Iterable<Group>?,
      onGroupCreate: freezed == onGroupCreate
          ? _value.onGroupCreate
          : onGroupCreate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<GroupCreateResult>?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl with DiagnosticableTreeMixin implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.loading, this.profile, this.groups, this.onGroupCreate});

  @override
  final bool loading;
  @override
  final Profile? profile;
  @override
  final Iterable<Group>? groups;
  @override
  final ValueSetter<GroupCreateResult>? onGroupCreate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, profile: $profile, groups: $groups, onGroupCreate: $onGroupCreate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('profile', profile))
      ..add(DiagnosticsProperty('groups', groups))
      ..add(DiagnosticsProperty('onGroupCreate', onGroupCreate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            const DeepCollectionEquality().equals(other.groups, groups) &&
            (identical(other.onGroupCreate, onGroupCreate) ||
                other.onGroupCreate == onGroupCreate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, profile,
      const DeepCollectionEquality().hash(groups), onGroupCreate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      __$$_ViewModelImplCopyWithImpl<_$_ViewModelImpl>(this, _$identity);
}

abstract class __ViewModel implements _ViewModel {
  const factory __ViewModel(
      {required final bool loading,
      final Profile? profile,
      final Iterable<Group>? groups,
      final ValueSetter<GroupCreateResult>? onGroupCreate}) = _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  Profile? get profile;
  @override
  Iterable<Group>? get groups;
  @override
  ValueSetter<GroupCreateResult>? get onGroupCreate;
  @override
  @JsonKey(ignore: true)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
