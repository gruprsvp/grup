// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ViewModel {
  bool get loading => throw _privateConstructorUsedError;
  bool get isAdmin => throw _privateConstructorUsedError;
  Group? get group => throw _privateConstructorUsedError;

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
  $Res call({bool loading, bool isAdmin, Group? group});

  $GroupCopyWith<$Res>? get group;
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
    Object? isAdmin = null,
    Object? group = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
    ) as $Val);
  }

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res>? get group {
    if (_value.group == null) {
      return null;
    }

    return $GroupCopyWith<$Res>(_value.group!, (value) {
      return _then(_value.copyWith(group: value) as $Val);
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
  $Res call({bool loading, bool isAdmin, Group? group});

  @override
  $GroupCopyWith<$Res>? get group;
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
    Object? isAdmin = null,
    Object? group = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl with DiagnosticableTreeMixin implements __ViewModel {
  const _$_ViewModelImpl(
      {required this.loading, required this.isAdmin, this.group});

  @override
  final bool loading;
  @override
  final bool isAdmin;
  @override
  final Group? group;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, isAdmin: $isAdmin, group: $group)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('isAdmin', isAdmin))
      ..add(DiagnosticsProperty('group', group));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.group, group) || other.group == group));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, isAdmin, group);

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
      required final bool isAdmin,
      final Group? group}) = _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  bool get isAdmin;
  @override
  Group? get group;

  /// Create a copy of _ViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
