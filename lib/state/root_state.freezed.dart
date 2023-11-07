// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'root_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RootState _$RootStateFromJson(Map<String, dynamic> json) {
  return _RootState.fromJson(json);
}

/// @nodoc
mixin _$RootState {
  RemoteEntityState<Profile> get profiles => throw _privateConstructorUsedError;
  RemoteEntityState<Group> get groups => throw _privateConstructorUsedError;
  RemoteEntityState<Schedule> get schedules =>
      throw _privateConstructorUsedError;
  RemoteEntityState<DefaultReply> get defaultReplies =>
      throw _privateConstructorUsedError;
  RemoteEntityState<Reply> get replies => throw _privateConstructorUsedError;
  AuthState get auth => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  LocaleState get locale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RootStateCopyWith<RootState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RootStateCopyWith<$Res> {
  factory $RootStateCopyWith(RootState value, $Res Function(RootState) then) =
      _$RootStateCopyWithImpl<$Res, RootState>;
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultReply> defaultReplies,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      LocaleState locale});

  $AuthStateCopyWith<$Res> get auth;
  $LocaleStateCopyWith<$Res> get locale;
}

/// @nodoc
class _$RootStateCopyWithImpl<$Res, $Val extends RootState>
    implements $RootStateCopyWith<$Res> {
  _$RootStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? groups = null,
    Object? schedules = null,
    Object? defaultReplies = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? locale = null,
  }) {
    return _then(_value.copyWith(
      profiles: null == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Profile>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Group>,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Schedule>,
      defaultReplies: null == defaultReplies
          ? _value.defaultReplies
          : defaultReplies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<DefaultReply>,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Reply>,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as AuthState,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<$Res> get auth {
    return $AuthStateCopyWith<$Res>(_value.auth, (value) {
      return _then(_value.copyWith(auth: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocaleStateCopyWith<$Res> get locale {
    return $LocaleStateCopyWith<$Res>(_value.locale, (value) {
      return _then(_value.copyWith(locale: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RootStateImplCopyWith<$Res>
    implements $RootStateCopyWith<$Res> {
  factory _$$RootStateImplCopyWith(
          _$RootStateImpl value, $Res Function(_$RootStateImpl) then) =
      __$$RootStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultReply> defaultReplies,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      LocaleState locale});

  @override
  $AuthStateCopyWith<$Res> get auth;
  @override
  $LocaleStateCopyWith<$Res> get locale;
}

/// @nodoc
class __$$RootStateImplCopyWithImpl<$Res>
    extends _$RootStateCopyWithImpl<$Res, _$RootStateImpl>
    implements _$$RootStateImplCopyWith<$Res> {
  __$$RootStateImplCopyWithImpl(
      _$RootStateImpl _value, $Res Function(_$RootStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? groups = null,
    Object? schedules = null,
    Object? defaultReplies = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? locale = null,
  }) {
    return _then(_$RootStateImpl(
      profiles: null == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Profile>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Group>,
      schedules: null == schedules
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Schedule>,
      defaultReplies: null == defaultReplies
          ? _value.defaultReplies
          : defaultReplies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<DefaultReply>,
      replies: null == replies
          ? _value.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Reply>,
      auth: null == auth
          ? _value.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as AuthState,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RootStateImpl with DiagnosticableTreeMixin implements _RootState {
  const _$RootStateImpl(
      {this.profiles = const RemoteEntityState<Profile>(),
      this.groups = const RemoteEntityState<Group>(),
      this.schedules = const RemoteEntityState<Schedule>(),
      this.defaultReplies = const RemoteEntityState<DefaultReply>(),
      this.replies = const RemoteEntityState<Reply>(),
      this.auth = const AuthState(status: AuthStatus.initial),
      this.themeMode = ThemeMode.system,
      this.locale = const LocaleState(languageCode: 'und')});

  factory _$RootStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RootStateImplFromJson(json);

  @override
  @JsonKey()
  final RemoteEntityState<Profile> profiles;
  @override
  @JsonKey()
  final RemoteEntityState<Group> groups;
  @override
  @JsonKey()
  final RemoteEntityState<Schedule> schedules;
  @override
  @JsonKey()
  final RemoteEntityState<DefaultReply> defaultReplies;
  @override
  @JsonKey()
  final RemoteEntityState<Reply> replies;
  @override
  @JsonKey()
  final AuthState auth;
  @override
  @JsonKey()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final LocaleState locale;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'RootState(profiles: $profiles, groups: $groups, schedules: $schedules, defaultReplies: $defaultReplies, replies: $replies, auth: $auth, themeMode: $themeMode, locale: $locale)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'RootState'))
      ..add(DiagnosticsProperty('profiles', profiles))
      ..add(DiagnosticsProperty('groups', groups))
      ..add(DiagnosticsProperty('schedules', schedules))
      ..add(DiagnosticsProperty('defaultReplies', defaultReplies))
      ..add(DiagnosticsProperty('replies', replies))
      ..add(DiagnosticsProperty('auth', auth))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('locale', locale));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RootStateImpl &&
            (identical(other.profiles, profiles) ||
                other.profiles == profiles) &&
            (identical(other.groups, groups) || other.groups == groups) &&
            (identical(other.schedules, schedules) ||
                other.schedules == schedules) &&
            (identical(other.defaultReplies, defaultReplies) ||
                other.defaultReplies == defaultReplies) &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, profiles, groups, schedules,
      defaultReplies, replies, auth, themeMode, locale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RootStateImplCopyWith<_$RootStateImpl> get copyWith =>
      __$$RootStateImplCopyWithImpl<_$RootStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RootStateImplToJson(
      this,
    );
  }
}

abstract class _RootState implements RootState {
  const factory _RootState(
      {final RemoteEntityState<Profile> profiles,
      final RemoteEntityState<Group> groups,
      final RemoteEntityState<Schedule> schedules,
      final RemoteEntityState<DefaultReply> defaultReplies,
      final RemoteEntityState<Reply> replies,
      final AuthState auth,
      final ThemeMode themeMode,
      final LocaleState locale}) = _$RootStateImpl;

  factory _RootState.fromJson(Map<String, dynamic> json) =
      _$RootStateImpl.fromJson;

  @override
  RemoteEntityState<Profile> get profiles;
  @override
  RemoteEntityState<Group> get groups;
  @override
  RemoteEntityState<Schedule> get schedules;
  @override
  RemoteEntityState<DefaultReply> get defaultReplies;
  @override
  RemoteEntityState<Reply> get replies;
  @override
  AuthState get auth;
  @override
  ThemeMode get themeMode;
  @override
  LocaleState get locale;
  @override
  @JsonKey(ignore: true)
  _$$RootStateImplCopyWith<_$RootStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
