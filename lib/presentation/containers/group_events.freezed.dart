// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ViewModel {
  bool get loading => throw _privateConstructorUsedError;
  Group? get group => throw _privateConstructorUsedError;
  Iterable<Schedule>? get schedules => throw _privateConstructorUsedError;
  ValueSetter<Schedule>? get onScheduleCreate =>
      throw _privateConstructorUsedError;
  ValueSetter<Schedule>? get onScheduleDelete =>
      throw _privateConstructorUsedError;
  Future<RruleL10n>? get rrulel10n => throw _privateConstructorUsedError;

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
      Group? group,
      Iterable<Schedule>? schedules,
      ValueSetter<Schedule>? onScheduleCreate,
      ValueSetter<Schedule>? onScheduleDelete,
      Future<RruleL10n>? rrulel10n});
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
    Object? group = freezed,
    Object? schedules = freezed,
    Object? onScheduleCreate = freezed,
    Object? onScheduleDelete = freezed,
    Object? rrulel10n = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      schedules: freezed == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<Schedule>?,
      onScheduleCreate: freezed == onScheduleCreate
          ? _value.onScheduleCreate
          : onScheduleCreate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Schedule>?,
      onScheduleDelete: freezed == onScheduleDelete
          ? _value.onScheduleDelete
          : onScheduleDelete // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Schedule>?,
      rrulel10n: freezed == rrulel10n
          ? _value.rrulel10n
          : rrulel10n // ignore: cast_nullable_to_non_nullable
              as Future<RruleL10n>?,
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
      Group? group,
      Iterable<Schedule>? schedules,
      ValueSetter<Schedule>? onScheduleCreate,
      ValueSetter<Schedule>? onScheduleDelete,
      Future<RruleL10n>? rrulel10n});
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
    Object? group = freezed,
    Object? schedules = freezed,
    Object? onScheduleCreate = freezed,
    Object? onScheduleDelete = freezed,
    Object? rrulel10n = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      schedules: freezed == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<Schedule>?,
      onScheduleCreate: freezed == onScheduleCreate
          ? _value.onScheduleCreate
          : onScheduleCreate // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Schedule>?,
      onScheduleDelete: freezed == onScheduleDelete
          ? _value.onScheduleDelete
          : onScheduleDelete // ignore: cast_nullable_to_non_nullable
              as ValueSetter<Schedule>?,
      rrulel10n: freezed == rrulel10n
          ? _value.rrulel10n
          : rrulel10n // ignore: cast_nullable_to_non_nullable
              as Future<RruleL10n>?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.loading,
      this.group,
      this.schedules,
      this.onScheduleCreate,
      this.onScheduleDelete,
      this.rrulel10n});

  @override
  final bool loading;
  @override
  final Group? group;
  @override
  final Iterable<Schedule>? schedules;
  @override
  final ValueSetter<Schedule>? onScheduleCreate;
  @override
  final ValueSetter<Schedule>? onScheduleDelete;
  @override
  final Future<RruleL10n>? rrulel10n;

  @override
  String toString() {
    return '_ViewModel(loading: $loading, group: $group, schedules: $schedules, onScheduleCreate: $onScheduleCreate, onScheduleDelete: $onScheduleDelete, rrulel10n: $rrulel10n)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other.schedules, schedules) &&
            (identical(other.onScheduleCreate, onScheduleCreate) ||
                other.onScheduleCreate == onScheduleCreate) &&
            (identical(other.onScheduleDelete, onScheduleDelete) ||
                other.onScheduleDelete == onScheduleDelete) &&
            (identical(other.rrulel10n, rrulel10n) ||
                other.rrulel10n == rrulel10n));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      group,
      const DeepCollectionEquality().hash(schedules),
      onScheduleCreate,
      onScheduleDelete,
      rrulel10n);

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
      final Group? group,
      final Iterable<Schedule>? schedules,
      final ValueSetter<Schedule>? onScheduleCreate,
      final ValueSetter<Schedule>? onScheduleDelete,
      final Future<RruleL10n>? rrulel10n}) = _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  Group? get group;
  @override
  Iterable<Schedule>? get schedules;
  @override
  ValueSetter<Schedule>? get onScheduleCreate;
  @override
  ValueSetter<Schedule>? get onScheduleDelete;
  @override
  Future<RruleL10n>? get rrulel10n;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
