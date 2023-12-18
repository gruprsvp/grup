// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ViewModel {
  bool get loading => throw _privateConstructorUsedError;
  OnGroupSaveCallback get onSave => throw _privateConstructorUsedError;
  Group? get group => throw _privateConstructorUsedError;

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
  $Res call({bool loading, OnGroupSaveCallback onSave, Group? group});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? onSave = null,
    Object? group = freezed,
  }) {
    return _then(_value.copyWith(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      onSave: null == onSave
          ? _value.onSave
          : onSave // ignore: cast_nullable_to_non_nullable
              as OnGroupSaveCallback,
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
    ) as $Val);
  }

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
  $Res call({bool loading, OnGroupSaveCallback onSave, Group? group});

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

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? onSave = null,
    Object? group = freezed,
  }) {
    return _then(_$_ViewModelImpl(
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      onSave: null == onSave
          ? _value.onSave
          : onSave // ignore: cast_nullable_to_non_nullable
              as OnGroupSaveCallback,
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
      {required this.loading, required this.onSave, this.group});

  @override
  final bool loading;
  @override
  final OnGroupSaveCallback onSave;
  @override
  final Group? group;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(loading: $loading, onSave: $onSave, group: $group)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('loading', loading))
      ..add(DiagnosticsProperty('onSave', onSave))
      ..add(DiagnosticsProperty('group', group));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.onSave, onSave) || other.onSave == onSave) &&
            (identical(other.group, group) || other.group == group));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loading, onSave, group);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      __$$_ViewModelImplCopyWithImpl<_$_ViewModelImpl>(this, _$identity);
}

abstract class __ViewModel implements _ViewModel {
  const factory __ViewModel(
      {required final bool loading,
      required final OnGroupSaveCallback onSave,
      final Group? group}) = _$_ViewModelImpl;

  @override
  bool get loading;
  @override
  OnGroupSaveCallback get onSave;
  @override
  Group? get group;
  @override
  @JsonKey(ignore: true)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
