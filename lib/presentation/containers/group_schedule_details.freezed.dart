// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_schedule_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ViewModel implements DiagnosticableTreeMixin {
  bool get loading;
  Group? get group;
  ScheduleInstanceDetails? get scheduleInstance;
  OnDetailsReplyChangedCallback? get onReplyChanged;
  OnDetailsDefaultRuleChangedCallback? get onDefaultRuleChanged;

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
            other is _ViewModel &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, group: $group, scheduleInstance: $scheduleInstance, onReplyChanged: $onReplyChanged, onDefaultRuleChanged: $onDefaultRuleChanged)';
  }
}

/// @nodoc
abstract mixin class _$ViewModelCopyWith<$Res> {
  factory _$ViewModelCopyWith(
          _ViewModel value, $Res Function(_ViewModel) _then) =
      __$ViewModelCopyWithImpl;
  @useResult
  $Res call(
      {bool loading,
      Group? group,
      ScheduleInstanceDetails? scheduleInstance,
      OnDetailsReplyChangedCallback? onReplyChanged,
      OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged});

  $GroupCopyWith<$Res>? get group;
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance;
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
    Object? loading = null,
    Object? group = freezed,
    Object? scheduleInstance = freezed,
    Object? onReplyChanged = freezed,
    Object? onDefaultRuleChanged = freezed,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      scheduleInstance: freezed == scheduleInstance
          ? _self.scheduleInstance
          : scheduleInstance // ignore: cast_nullable_to_non_nullable
              as ScheduleInstanceDetails?,
      onReplyChanged: freezed == onReplyChanged
          ? _self.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsReplyChangedCallback?,
      onDefaultRuleChanged: freezed == onDefaultRuleChanged
          ? _self.onDefaultRuleChanged
          : onDefaultRuleChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsDefaultRuleChangedCallback?,
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

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance {
    if (_self.scheduleInstance == null) {
      return null;
    }

    return $ScheduleInstanceDetailsCopyWith<$Res>(_self.scheduleInstance!,
        (value) {
      return _then(_self.copyWith(scheduleInstance: value));
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
            bool loading,
            Group? group,
            ScheduleInstanceDetails? scheduleInstance,
            OnDetailsReplyChangedCallback? onReplyChanged,
            OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.loading, _that.group, _that.scheduleInstance,
            _that.onReplyChanged, _that.onDefaultRuleChanged);
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
            bool loading,
            Group? group,
            ScheduleInstanceDetails? scheduleInstance,
            OnDetailsReplyChangedCallback? onReplyChanged,
            OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel():
        return $default(_that.loading, _that.group, _that.scheduleInstance,
            _that.onReplyChanged, _that.onDefaultRuleChanged);
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
            bool loading,
            Group? group,
            ScheduleInstanceDetails? scheduleInstance,
            OnDetailsReplyChangedCallback? onReplyChanged,
            OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case __ViewModel() when $default != null:
        return $default(_that.loading, _that.group, _that.scheduleInstance,
            _that.onReplyChanged, _that.onDefaultRuleChanged);
      case _:
        return null;
    }
  }
}

/// @nodoc

class __ViewModel with DiagnosticableTreeMixin implements _ViewModel {
  const __ViewModel(
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
            other is __ViewModel &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, group: $group, scheduleInstance: $scheduleInstance, onReplyChanged: $onReplyChanged, onDefaultRuleChanged: $onDefaultRuleChanged)';
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
      {bool loading,
      Group? group,
      ScheduleInstanceDetails? scheduleInstance,
      OnDetailsReplyChangedCallback? onReplyChanged,
      OnDetailsDefaultRuleChangedCallback? onDefaultRuleChanged});

  @override
  $GroupCopyWith<$Res>? get group;
  @override
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance;
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
    Object? loading = null,
    Object? group = freezed,
    Object? scheduleInstance = freezed,
    Object? onReplyChanged = freezed,
    Object? onDefaultRuleChanged = freezed,
  }) {
    return _then(__ViewModel(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _self.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      scheduleInstance: freezed == scheduleInstance
          ? _self.scheduleInstance
          : scheduleInstance // ignore: cast_nullable_to_non_nullable
              as ScheduleInstanceDetails?,
      onReplyChanged: freezed == onReplyChanged
          ? _self.onReplyChanged
          : onReplyChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsReplyChangedCallback?,
      onDefaultRuleChanged: freezed == onDefaultRuleChanged
          ? _self.onDefaultRuleChanged
          : onDefaultRuleChanged // ignore: cast_nullable_to_non_nullable
              as OnDetailsDefaultRuleChangedCallback?,
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

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleInstanceDetailsCopyWith<$Res>? get scheduleInstance {
    if (_self.scheduleInstance == null) {
      return null;
    }

    return $ScheduleInstanceDetailsCopyWith<$Res>(_self.scheduleInstance!,
        (value) {
      return _then(_self.copyWith(scheduleInstance: value));
    });
  }
}

// dart format on
