// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedules_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ViewModel {
  ValueChanged<DateTime> get onDateChanged =>
      throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  Iterable<ScheduleInstanceSummary>? get schedules =>
      throw _privateConstructorUsedError;
  OnReplyChangedCallback? get onReplyChanged =>
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
      {ValueChanged<DateTime> onDateChanged,
      bool isAdmin,
      DateTime? selectedDate,
      Iterable<ScheduleInstanceSummary>? schedules,
      OnReplyChangedCallback? onReplyChanged});
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
    Object? onDateChanged = null,
    Object? isAdmin = null,
    Object? selectedDate = freezed,
    Object? schedules = freezed,
    Object? onReplyChanged = freezed,
  }) {
    return _then(_value.copyWith(
      onDateChanged: null == onDateChanged
          ? _value.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedules: freezed == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<ScheduleInstanceSummary>?,
      onReplyChanged: freezed == onReplyChanged
          ? _value.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnReplyChangedCallback?,
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
      {ValueChanged<DateTime> onDateChanged,
      bool isAdmin,
      DateTime? selectedDate,
      Iterable<ScheduleInstanceSummary>? schedules,
      OnReplyChangedCallback? onReplyChanged});
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
    Object? onDateChanged = null,
    Object? isAdmin = null,
    Object? selectedDate = freezed,
    Object? schedules = freezed,
    Object? onReplyChanged = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      onDateChanged: null == onDateChanged
          ? _value.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedules: freezed == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<ScheduleInstanceSummary>?,
      onReplyChanged: freezed == onReplyChanged
          ? _value.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnReplyChangedCallback?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl with DiagnosticableTreeMixin implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.onDateChanged,
      required this.isAdmin,
      this.selectedDate,
      this.schedules,
      this.onReplyChanged});

  @override
  final ValueChanged<DateTime> onDateChanged;
  @override
  final bool isAdmin;
  @override
  final DateTime? selectedDate;
  @override
  final Iterable<ScheduleInstanceSummary>? schedules;
  @override
  final OnReplyChangedCallback? onReplyChanged;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(onDateChanged: $onDateChanged, isAdmin: $isAdmin, selectedDate: $selectedDate, schedules: $schedules, onReplyChanged: $onReplyChanged)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('onDateChanged', onDateChanged))
      ..add(DiagnosticsProperty('isAdmin', isAdmin))
      ..add(DiagnosticsProperty('selectedDate', selectedDate))
      ..add(DiagnosticsProperty('schedules', schedules))
      ..add(DiagnosticsProperty('onReplyChanged', onReplyChanged));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.onDateChanged, onDateChanged) ||
                other.onDateChanged == onDateChanged) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            const DeepCollectionEquality().equals(other.schedules, schedules) &&
            (identical(other.onReplyChanged, onReplyChanged) ||
                other.onReplyChanged == onReplyChanged));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      onDateChanged,
      isAdmin,
      selectedDate,
      const DeepCollectionEquality().hash(schedules),
      onReplyChanged);

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
      {required final ValueChanged<DateTime> onDateChanged,
      required final bool isAdmin,
      final DateTime? selectedDate,
      final Iterable<ScheduleInstanceSummary>? schedules,
      final OnReplyChangedCallback? onReplyChanged}) = _$_ViewModelImpl;

  @override
  ValueChanged<DateTime> get onDateChanged;
  @override
  bool get isAdmin;
  @override
  DateTime? get selectedDate;
  @override
  Iterable<ScheduleInstanceSummary>? get schedules;
  @override
  OnReplyChangedCallback? get onReplyChanged;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
