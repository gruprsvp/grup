// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locale_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LocaleState _$LocaleStateFromJson(Map<String, dynamic> json) {
  return _LocaleState.fromJson(json);
}

/// @nodoc
mixin _$LocaleState {
  String get languageCode => throw _privateConstructorUsedError;
  String? get scriptCode => throw _privateConstructorUsedError;
  String? get countryCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocaleStateCopyWith<LocaleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocaleStateCopyWith<$Res> {
  factory $LocaleStateCopyWith(
          LocaleState value, $Res Function(LocaleState) then) =
      _$LocaleStateCopyWithImpl<$Res, LocaleState>;
  @useResult
  $Res call({String languageCode, String? scriptCode, String? countryCode});
}

/// @nodoc
class _$LocaleStateCopyWithImpl<$Res, $Val extends LocaleState>
    implements $LocaleStateCopyWith<$Res> {
  _$LocaleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? scriptCode = freezed,
    Object? countryCode = freezed,
  }) {
    return _then(_value.copyWith(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      scriptCode: freezed == scriptCode
          ? _value.scriptCode
          : scriptCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocaleStateImplCopyWith<$Res>
    implements $LocaleStateCopyWith<$Res> {
  factory _$$LocaleStateImplCopyWith(
          _$LocaleStateImpl value, $Res Function(_$LocaleStateImpl) then) =
      __$$LocaleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String languageCode, String? scriptCode, String? countryCode});
}

/// @nodoc
class __$$LocaleStateImplCopyWithImpl<$Res>
    extends _$LocaleStateCopyWithImpl<$Res, _$LocaleStateImpl>
    implements _$$LocaleStateImplCopyWith<$Res> {
  __$$LocaleStateImplCopyWithImpl(
      _$LocaleStateImpl _value, $Res Function(_$LocaleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? scriptCode = freezed,
    Object? countryCode = freezed,
  }) {
    return _then(_$LocaleStateImpl(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      scriptCode: freezed == scriptCode
          ? _value.scriptCode
          : scriptCode // ignore: cast_nullable_to_non_nullable
              as String?,
      countryCode: freezed == countryCode
          ? _value.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocaleStateImpl with DiagnosticableTreeMixin implements _LocaleState {
  const _$LocaleStateImpl(
      {required this.languageCode, this.scriptCode, this.countryCode});

  factory _$LocaleStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocaleStateImplFromJson(json);

  @override
  final String languageCode;
  @override
  final String? scriptCode;
  @override
  final String? countryCode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LocaleState(languageCode: $languageCode, scriptCode: $scriptCode, countryCode: $countryCode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LocaleState'))
      ..add(DiagnosticsProperty('languageCode', languageCode))
      ..add(DiagnosticsProperty('scriptCode', scriptCode))
      ..add(DiagnosticsProperty('countryCode', countryCode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocaleStateImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.scriptCode, scriptCode) ||
                other.scriptCode == scriptCode) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, languageCode, scriptCode, countryCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocaleStateImplCopyWith<_$LocaleStateImpl> get copyWith =>
      __$$LocaleStateImplCopyWithImpl<_$LocaleStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocaleStateImplToJson(
      this,
    );
  }
}

abstract class _LocaleState implements LocaleState {
  const factory _LocaleState(
      {required final String languageCode,
      final String? scriptCode,
      final String? countryCode}) = _$LocaleStateImpl;

  factory _LocaleState.fromJson(Map<String, dynamic> json) =
      _$LocaleStateImpl.fromJson;

  @override
  String get languageCode;
  @override
  String? get scriptCode;
  @override
  String? get countryCode;
  @override
  @JsonKey(ignore: true)
  _$$LocaleStateImplCopyWith<_$LocaleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
