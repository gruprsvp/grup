// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppState {
  RemoteEntityState<Profile> get profiles => throw _privateConstructorUsedError;
  RemoteEntityState<Group> get groups => throw _privateConstructorUsedError;
  RemoteEntityState<Member> get members => throw _privateConstructorUsedError;
  RemoteEntityState<Invite> get invites => throw _privateConstructorUsedError;
  RemoteEntityState<Schedule> get schedules =>
      throw _privateConstructorUsedError;
  RemoteEntityState<DefaultReply> get defaultReplies =>
      throw _privateConstructorUsedError;
  RemoteEntityState<Reply> get replies => throw _privateConstructorUsedError;
  AuthState get auth => throw _privateConstructorUsedError;
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  DateTime get selectedDate => throw _privateConstructorUsedError;
  String? get selectedGroupId => throw _privateConstructorUsedError;
  String? get selectedScheduleId => throw _privateConstructorUsedError;
  LocaleState? get locale => throw _privateConstructorUsedError;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Member> members,
      RemoteEntityState<Invite> invites,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultReply> defaultReplies,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      DateTime selectedDate,
      String? selectedGroupId,
      String? selectedScheduleId,
      LocaleState? locale});

  $AuthStateCopyWith<$Res> get auth;
  $LocaleStateCopyWith<$Res>? get locale;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? groups = null,
    Object? members = null,
    Object? invites = null,
    Object? schedules = null,
    Object? defaultReplies = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? selectedDate = null,
    Object? selectedGroupId = freezed,
    Object? selectedScheduleId = freezed,
    Object? locale = freezed,
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
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Member>,
      invites: null == invites
          ? _value.invites
          : invites // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Invite>,
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
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedGroupId: freezed == selectedGroupId
          ? _value.selectedGroupId
          : selectedGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedScheduleId: freezed == selectedScheduleId
          ? _value.selectedScheduleId
          : selectedScheduleId // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState?,
    ) as $Val);
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<$Res> get auth {
    return $AuthStateCopyWith<$Res>(_value.auth, (value) {
      return _then(_value.copyWith(auth: value) as $Val);
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocaleStateCopyWith<$Res>? get locale {
    if (_value.locale == null) {
      return null;
    }

    return $LocaleStateCopyWith<$Res>(_value.locale!, (value) {
      return _then(_value.copyWith(locale: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppStateImplCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$$AppStateImplCopyWith(
          _$AppStateImpl value, $Res Function(_$AppStateImpl) then) =
      __$$AppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Member> members,
      RemoteEntityState<Invite> invites,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultReply> defaultReplies,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      DateTime selectedDate,
      String? selectedGroupId,
      String? selectedScheduleId,
      LocaleState? locale});

  @override
  $AuthStateCopyWith<$Res> get auth;
  @override
  $LocaleStateCopyWith<$Res>? get locale;
}

/// @nodoc
class __$$AppStateImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateImpl>
    implements _$$AppStateImplCopyWith<$Res> {
  __$$AppStateImplCopyWithImpl(
      _$AppStateImpl _value, $Res Function(_$AppStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profiles = null,
    Object? groups = null,
    Object? members = null,
    Object? invites = null,
    Object? schedules = null,
    Object? defaultReplies = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? selectedDate = null,
    Object? selectedGroupId = freezed,
    Object? selectedScheduleId = freezed,
    Object? locale = freezed,
  }) {
    return _then(_$AppStateImpl(
      profiles: null == profiles
          ? _value.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Profile>,
      groups: null == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Group>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Member>,
      invites: null == invites
          ? _value.invites
          : invites // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Invite>,
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
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedGroupId: freezed == selectedGroupId
          ? _value.selectedGroupId
          : selectedGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedScheduleId: freezed == selectedScheduleId
          ? _value.selectedScheduleId
          : selectedScheduleId // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState?,
    ));
  }
}

/// @nodoc

class _$AppStateImpl with DiagnosticableTreeMixin implements _AppState {
  const _$AppStateImpl(
      {this.profiles = const RemoteEntityState<Profile>(),
      this.groups = const RemoteEntityState<Group>(),
      this.members = const RemoteEntityState<Member>(),
      this.invites = const RemoteEntityState<Invite>(),
      this.schedules = const RemoteEntityState<Schedule>(),
      this.defaultReplies = const RemoteEntityState<DefaultReply>(),
      this.replies = const RemoteEntityState<Reply>(),
      this.auth = const AuthState(status: AuthStatus.initial),
      this.themeMode = ThemeMode.system,
      required this.selectedDate,
      this.selectedGroupId,
      this.selectedScheduleId,
      this.locale});

  @override
  @JsonKey()
  final RemoteEntityState<Profile> profiles;
  @override
  @JsonKey()
  final RemoteEntityState<Group> groups;
  @override
  @JsonKey()
  final RemoteEntityState<Member> members;
  @override
  @JsonKey()
  final RemoteEntityState<Invite> invites;
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
  final DateTime selectedDate;
  @override
  final String? selectedGroupId;
  @override
  final String? selectedScheduleId;
  @override
  final LocaleState? locale;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(profiles: $profiles, groups: $groups, members: $members, invites: $invites, schedules: $schedules, defaultReplies: $defaultReplies, replies: $replies, auth: $auth, themeMode: $themeMode, selectedDate: $selectedDate, selectedGroupId: $selectedGroupId, selectedScheduleId: $selectedScheduleId, locale: $locale)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('profiles', profiles))
      ..add(DiagnosticsProperty('groups', groups))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('invites', invites))
      ..add(DiagnosticsProperty('schedules', schedules))
      ..add(DiagnosticsProperty('defaultReplies', defaultReplies))
      ..add(DiagnosticsProperty('replies', replies))
      ..add(DiagnosticsProperty('auth', auth))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('selectedDate', selectedDate))
      ..add(DiagnosticsProperty('selectedGroupId', selectedGroupId))
      ..add(DiagnosticsProperty('selectedScheduleId', selectedScheduleId))
      ..add(DiagnosticsProperty('locale', locale));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateImpl &&
            (identical(other.profiles, profiles) ||
                other.profiles == profiles) &&
            (identical(other.groups, groups) || other.groups == groups) &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.invites, invites) || other.invites == invites) &&
            (identical(other.schedules, schedules) ||
                other.schedules == schedules) &&
            (identical(other.defaultReplies, defaultReplies) ||
                other.defaultReplies == defaultReplies) &&
            (identical(other.replies, replies) || other.replies == replies) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.selectedGroupId, selectedGroupId) ||
                other.selectedGroupId == selectedGroupId) &&
            (identical(other.selectedScheduleId, selectedScheduleId) ||
                other.selectedScheduleId == selectedScheduleId) &&
            (identical(other.locale, locale) || other.locale == locale));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      profiles,
      groups,
      members,
      invites,
      schedules,
      defaultReplies,
      replies,
      auth,
      themeMode,
      selectedDate,
      selectedGroupId,
      selectedScheduleId,
      locale);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      __$$AppStateImplCopyWithImpl<_$AppStateImpl>(this, _$identity);
}

abstract class _AppState implements AppState {
  const factory _AppState(
      {final RemoteEntityState<Profile> profiles,
      final RemoteEntityState<Group> groups,
      final RemoteEntityState<Member> members,
      final RemoteEntityState<Invite> invites,
      final RemoteEntityState<Schedule> schedules,
      final RemoteEntityState<DefaultReply> defaultReplies,
      final RemoteEntityState<Reply> replies,
      final AuthState auth,
      final ThemeMode themeMode,
      required final DateTime selectedDate,
      final String? selectedGroupId,
      final String? selectedScheduleId,
      final LocaleState? locale}) = _$AppStateImpl;

  @override
  RemoteEntityState<Profile> get profiles;
  @override
  RemoteEntityState<Group> get groups;
  @override
  RemoteEntityState<Member> get members;
  @override
  RemoteEntityState<Invite> get invites;
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
  DateTime get selectedDate;
  @override
  String? get selectedGroupId;
  @override
  String? get selectedScheduleId;
  @override
  LocaleState? get locale;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
