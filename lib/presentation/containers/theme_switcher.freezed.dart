// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_switcher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ViewModel {
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  void Function() get nextTheme => throw _privateConstructorUsedError;

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
  $Res call({ThemeMode themeMode, void Function() nextTheme});
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
    Object? themeMode = null,
    Object? nextTheme = null,
  }) {
    return _then(_value.copyWith(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      nextTheme: null == nextTheme
          ? _value.nextTheme
          : nextTheme // ignore: cast_nullable_to_non_nullable
              as void Function(),
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
  $Res call({ThemeMode themeMode, void Function() nextTheme});
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
    Object? themeMode = null,
    Object? nextTheme = null,
  }) {
    return _then(_$_ViewModelImpl(
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      nextTheme: null == nextTheme
          ? _value.nextTheme
          : nextTheme // ignore: cast_nullable_to_non_nullable
              as void Function(),
    ));
  }
}

/// @nodoc

class _$_ViewModelImpl with DiagnosticableTreeMixin implements __ViewModel {
  const _$_ViewModelImpl({required this.themeMode, required this.nextTheme});

  @override
  final ThemeMode themeMode;
  @override
  final void Function() nextTheme;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '_ViewModel(themeMode: $themeMode, nextTheme: $nextTheme)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', '_ViewModel'))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('nextTheme', nextTheme));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViewModelImpl &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.nextTheme, nextTheme) ||
                other.nextTheme == nextTheme));
  }

  @override
  int get hashCode => Object.hash(runtimeType, themeMode, nextTheme);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      __$$_ViewModelImplCopyWithImpl<_$_ViewModelImpl>(this, _$identity);
}

abstract class __ViewModel implements _ViewModel {
  const factory __ViewModel(
      {required final ThemeMode themeMode,
      required final void Function() nextTheme}) = _$_ViewModelImpl;

  @override
  ThemeMode get themeMode;
  @override
  void Function() get nextTheme;
  @override
  @JsonKey(ignore: true)
  _$$_ViewModelImplCopyWith<_$_ViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
