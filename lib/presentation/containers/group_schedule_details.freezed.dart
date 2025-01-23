// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_schedule_details.dart';

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
  ScheduleInstanceDetails? get scheduleInstance =>
      throw _privateConstructorUsedError;
  OnDetailsReplyChangedCallback? get onReplyChanged =>
      throw _privateConstructorUsedError;
  OnDetailsDefaultRuleChangedCallback? get onDefaultRuleChanged =>
      throw _privateConstructorUsedError;

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
      ScheduleInstanceDetails? scheduleInstance,
      OnDetailsReplyChangedCallback? onReplyChanged,
      OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged});

  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance;
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
    Object? scheduleInstance = freezed,
    Object? onReplyChanged = freezed,
    Object? onDefaultRuleChanged = freezed,
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
      scheduleInstance: freezed == scheduleInstance
          ? _value.scheduleInstance
          : scheduleInstance // ignore: cast_nullable_to_non_nullable
              as ScheduleInstanceDetails?,
      onReplyChanged: freezed == onReplyChanged
          ? _value.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsReplyChangedCallback?,
      onDefaultRuleChanged: freezed == onDefaultRuleChanged
          ? _value.onDefaultRuleChanged
          : onDefaultRuleChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsDefaultRuleChangedCallback?,
    ) as $Val);
  }

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance {
    if (_value.scheduleInstance == null) {
      return null;
    }

    return $ScheduleInstanceDetailsCopyWith<$Res>(_value.scheduleInstance!,
        (value) {
      return _then(_value.copyWith(scheduleInstance: value) as $Val);
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
      Group? group,
      ScheduleInstanceDetails? scheduleInstance,
      OnDetailsReplyChangedCallback? onReplyChanged,
      OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged});

  @override
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance;
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
    Object? scheduleInstance = freezed,
    Object? onReplyChanged = freezed,
    Object? onDefaultRuleChanged = freezed,
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
      scheduleInstance: freezed == scheduleInstance
          ? _value.scheduleInstance
          : scheduleInstance // ignore: cast_nullable_to_non_nullable
              as ScheduleInstanceDetails?,
      onReplyChanged: freezed == onReplyChanged
          ? _value.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsReplyChangedCallback?,
      onDefaultRuleChanged: freezed == onDefaultRuleChanged
          ? _value.onDefaultRuleChanged
          : onDefaultRuleChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsDefaultRuleChangedCallback?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl with DiagnosticableTreeMixin implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.loading,
      this.group,
      this.scheduleInstance,
      this.onReplyChanged,
      this.onDefaultRuleChanged});

  @override
  final bool loading;
  @override
  final Group? group;
  @override
  final ScheduleInstanceDetails? scheduleInstance;
  @override
  final OnDetailsReplyChangedCallback? onReplyChanged;
  @override
  final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, group: $group, scheduleInstance: $scheduleInstance, onReplyChanged: $onReplyChanged, onDefaultRuleChanged: $onDefaultRuleChanged)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('group', group))
      ..add(DiagnosticsProperty('scheduleInstance', scheduleInstance))
      ..add(DiagnosticsProperty('onReplyChanged', onReplyChanged))
      ..add(DiagnosticsProperty('onDefaultRuleChanged', onDefaultRuleChanged));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.scheduleInstance, scheduleInstance) ||
                other.scheduleInstance == scheduleInstance) &&
            (identical(other.onReplyChanged, onReplyChanged) ||
                other.onReplyChanged == onReplyChanged) &&
            (identical(other.onDefaultRuleChanged, onDefaultRuleChanged) ||
                other.onDefaultRuleChanged == onDefaultRuleChanged));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, group, scheduleInstance,
      onReplyChanged, onDefaultRuleChanged);

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
          final ScheduleInstanceDetails? scheduleInstance,
          final OnDetailsReplyChangedCallback? onReplyChanged,
          final OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged}) =
      _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  Group? get group;
  @override
  ScheduleInstanceDetails? get scheduleInstance;
  @override
  OnDetailsReplyChangedCallback? get onReplyChanged;
  @override
  OnDetailsDefaultRuleChangedCallback? get onDefaultRuleChanged;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
