// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_fab.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewModel {
  DateTime get selectedDate;
  ValueChanged<DateTime> get onDateChanged;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ViewModelCopyWith<_ViewModel> get copyWith =>
      __$ViewModelCopyWithImpl<_ViewModel>(this as _ViewModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ViewModel &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.onDateChanged, onDateChanged) ||
                other.onDateChanged == onDateChanged));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedDate, onDateChanged);

  @override
  String toString() {
    return '_ViewModel(selectedDate: $selectedDate, onDateChanged: $onDateChanged)';
  }
}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res> {
  factory _$ViewModelCopyWith(
          _ViewModel value, $Res Function(_ViewModel) _then) =
      __$ViewModelCopyWithImpl;
  @useResult
  $Res call({DateTime selectedDate, ValueChanged<DateTime> onDateChanged});
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
    Object? selectedDate = null,
    Object? onDateChanged = null,
  }) {
    return _then(_self.copyWith(
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      onDateChanged: null == onDateChanged
          ? _self.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
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
            DateTime selectedDate, ValueChanged<DateTime> onDateChanged)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.selectedDate, _that.onDateChanged);
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
            DateTime selectedDate, ValueChanged<DateTime> onDateChanged)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel():
        return $default(_that.selectedDate, _that.onDateChanged);
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
            DateTime selectedDate, ValueChanged<DateTime> onDateChanged)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.selectedDate, _that.onDateChanged);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __ViewModel implements _ViewModel {
  const __ViewModel({required this.selectedDate, required this.onDateChanged});

  @override
  final DateTime selectedDate;
  @override
  final ValueChanged<DateTime> onDateChanged;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$_ViewModelCopyWith<__ViewModel> get copyWith =>
      __$_ViewModelCopyWithImpl<__ViewModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is __ViewModel &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.onDateChanged, onDateChanged) ||
                other.onDateChanged == onDateChanged));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedDate, onDateChanged);

  @override
  String toString() {
    return '_ViewModel(selectedDate: $selectedDate, onDateChanged: $onDateChanged)';
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
  $Res call({DateTime selectedDate, ValueChanged<DateTime> onDateChanged});
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
    Object? selectedDate = null,
    Object? onDateChanged = null,
  }) {
    return _then(__ViewModel(
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      onDateChanged: null == onDateChanged
          ? _self.onDateChanged
          : onDateChanged // ignore: cast_nullable_to_non_nullable
              as ValueChanged<DateTime>,
    ));
  }
}

// dart format on
