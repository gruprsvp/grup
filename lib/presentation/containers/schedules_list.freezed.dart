// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedules_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewModel implements DiagnosticableTreeMixin {
  ValueChanged<DateTime> get onDateChanged;
  bool get isAdmin;
  DateTime? get selectedDate;
  Iterable<ScheduleInstanceSummary>? get schedules;
  OnReplyChangedCallback? get onReplyChanged;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ViewModelCopyWith<_ViewModel> get copyWith =>
      __$ViewModelCopyWithImpl<_ViewModel>(this as _ViewModel, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _ViewModel &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(onDateChanged: $onDateChanged, isAdmin: $isAdmin, selectedDate: $selectedDate, schedules: $schedules, onReplyChanged: $onReplyChanged)';
  }
}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res> {
  factory _$ViewModelCopyWith(
          _ViewModel value, $Res Function(_ViewModel) _then) =
      __$ViewModelCopyWithImpl;
  @useResult
  $Res call(
      {ValueChanged<DateTime> onDateChanged,
      bool isAdmin,
      DateTime? selectedDate,
      Iterable<ScheduleInstanceSummary>? schedules,
      OnReplyChangedCallback? onReplyChanged});
}

/// @nodoc
class __$ViewModelCopyWithImpl<$Res> implements _$ViewModelCopyWith<$Res> {
  __$ViewModelCopyWithImpl(this._self, this._then);

  final _ViewModel _self;
  final $Res Function(_ViewModel) _then;

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
    return _then(_self.copyWith(
      onDateChanged: null == onDateChanged
          ? _self.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedules: freezed == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<ScheduleInstanceSummary>?,
      onReplyChanged: freezed == onReplyChanged
          ? _self.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnReplyChangedCallback?,
    ));
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(__ViewModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(__ViewModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(__ViewModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            ValueChanged<DateTime> onDateChanged,
            bool isAdmin,
            DateTime? selectedDate,
            Iterable<ScheduleInstanceSummary>? schedules,
            OnReplyChangedCallback? onReplyChanged)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.onDateChanged, _that.isAdmin, _that.selectedDate,
            _that.schedules, _that.onReplyChanged);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            ValueChanged<DateTime> onDateChanged,
            bool isAdmin,
            DateTime? selectedDate,
            Iterable<ScheduleInstanceSummary>? schedules,
            OnReplyChangedCallback? onReplyChanged)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel():
        return $default(_that.onDateChanged, _that.isAdmin, _that.selectedDate,
            _that.schedules, _that.onReplyChanged);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            ValueChanged<DateTime> onDateChanged,
            bool isAdmin,
            DateTime? selectedDate,
            Iterable<ScheduleInstanceSummary>? schedules,
            OnReplyChangedCallback? onReplyChanged)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.onDateChanged, _that.isAdmin, _that.selectedDate,
            _that.schedules, _that.onReplyChanged);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __ViewModel with DiagnosticableTreeMixin implements _ViewModel {
  const __ViewModel(
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

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_ViewModelCopyWith<__ViewModel> get copyWith =>
      __$_ViewModelCopyWithImpl<__ViewModel>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is __ViewModel &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(onDateChanged: $onDateChanged, isAdmin: $isAdmin, selectedDate: $selectedDate, schedules: $schedules, onReplyChanged: $onReplyChanged)';
  }
}

/// @nodoc
abstract mixin class _$_ViewModelCopyWith<$Res>
    implements _$ViewModelCopyWith<$Res> {
  factory _$_ViewModelCopyWith(
          __ViewModel value, $Res Function(__ViewModel) _then) =
      __$_ViewModelCopyWithImpl;
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
class __$_ViewModelCopyWithImpl<$Res> implements _$_ViewModelCopyWith<$Res> {
  __$_ViewModelCopyWithImpl(this._self, this._then);

  final __ViewModel _self;
  final $Res Function(__ViewModel) _then;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? onDateChanged = null,
    Object? isAdmin = null,
    Object? selectedDate = freezed,
    Object? schedules = freezed,
    Object? onReplyChanged = freezed,
  }) {
    return _then(__ViewModel(
      onDateChanged: null == onDateChanged
          ? _self.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDate: freezed == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      schedules: freezed == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as Iterable<ScheduleInstanceSummary>?,
      onReplyChanged: freezed == onReplyChanged
          ? _self.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnReplyChangedCallback?,
    ));
  }
}

// dart format on
