// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'locale_state.dart';

class LocaleStateMapper extends ClassMapperBase<LocaleState> {
  LocaleStateMapper._();

  static LocaleStateMapper? _instance;
  static LocaleStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LocaleStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LocaleState';

  static String _$languageCode(LocaleState v) => v.languageCode;
  static const Field<LocaleState, String> _f$languageCode =
      Field('languageCode', _$languageCode);
  static String? _$scriptCode(LocaleState v) => v.scriptCode;
  static const Field<LocaleState, String> _f$scriptCode =
      Field('scriptCode', _$scriptCode, opt: true);
  static String? _$countryCode(LocaleState v) => v.countryCode;
  static const Field<LocaleState, String> _f$countryCode =
      Field('countryCode', _$countryCode, opt: true);

  @override
  final MappableFields<LocaleState> fields = const {
    #languageCode: _f$languageCode,
    #scriptCode: _f$scriptCode,
    #countryCode: _f$countryCode,
  };

  static LocaleState _instantiate(DecodingData data) {
    return LocaleState(
        languageCode: data.dec(_f$languageCode),
        scriptCode: data.dec(_f$scriptCode),
        countryCode: data.dec(_f$countryCode));
  }

  @override
  final Function instantiate = _instantiate;

  static LocaleState fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LocaleState>(map);
  }

  static LocaleState fromJsonString(String json) {
    return ensureInitialized().decodeJson<LocaleState>(json);
  }
}

mixin LocaleStateMappable {
  String toJsonString() {
    return LocaleStateMapper.ensureInitialized()
        .encodeJson<LocaleState>(this as LocaleState);
  }

  Map<String, dynamic> toJson() {
    return LocaleStateMapper.ensureInitialized()
        .encodeMap<LocaleState>(this as LocaleState);
  }

  LocaleStateCopyWith<LocaleState, LocaleState, LocaleState> get copyWith =>
      _LocaleStateCopyWithImpl(this as LocaleState, $identity, $identity);
  @override
  String toString() {
    return LocaleStateMapper.ensureInitialized()
        .stringifyValue(this as LocaleState);
  }

  @override
  bool operator ==(Object other) {
    return LocaleStateMapper.ensureInitialized()
        .equalsValue(this as LocaleState, other);
  }

  @override
  int get hashCode {
    return LocaleStateMapper.ensureInitialized().hashValue(this as LocaleState);
  }
}

extension LocaleStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LocaleState, $Out> {
  LocaleStateCopyWith<$R, LocaleState, $Out> get $asLocaleState =>
      $base.as((v, t, t2) => _LocaleStateCopyWithImpl(v, t, t2));
}

abstract class LocaleStateCopyWith<$R, $In extends LocaleState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? languageCode, String? scriptCode, String? countryCode});
  LocaleStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LocaleStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LocaleState, $Out>
    implements LocaleStateCopyWith<$R, LocaleState, $Out> {
  _LocaleStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LocaleState> $mapper =
      LocaleStateMapper.ensureInitialized();
  @override
  $R call(
          {String? languageCode,
          Object? scriptCode = $none,
          Object? countryCode = $none}) =>
      $apply(FieldCopyWithData({
        if (languageCode != null) #languageCode: languageCode,
        if (scriptCode != $none) #scriptCode: scriptCode,
        if (countryCode != $none) #countryCode: countryCode
      }));
  @override
  LocaleState $make(CopyWithData data) => LocaleState(
      languageCode: data.get(#languageCode, or: $value.languageCode),
      scriptCode: data.get(#scriptCode, or: $value.scriptCode),
      countryCode: data.get(#countryCode, or: $value.countryCode));

  @override
  LocaleStateCopyWith<$R2, LocaleState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _LocaleStateCopyWithImpl($value, $cast, t);
}
