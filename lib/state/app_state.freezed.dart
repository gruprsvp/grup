// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppState implements DiagnosticableTreeMixin {
  RemoteEntityState<Profile> get profiles;
  RemoteEntityState<Group> get groups;
  RemoteEntityState<Member> get members;
  RemoteEntityState<Invite> get invites;
  RemoteEntityState<Schedule> get schedules;
  RemoteEntityState<DefaultRule> get defaultRules;
  RemoteEntityState<Reply> get replies;
  AuthState get auth;
  ThemeMode get themeMode;
  DateTime get selectedDate;
  String? get selectedGroupId;
  String? get selectedScheduleId;
  LocaleState? get locale;
  bool? get hasSeenFeedbackCard;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppStateCopyWith<AppState> get copyWith =>
      _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);

  /// Serializes this AppState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('profiles', profiles))
      ..add(DiagnosticsProperty('groups', groups))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('invites', invites))
      ..add(DiagnosticsProperty('schedules', schedules))
      ..add(DiagnosticsProperty('defaultRules', defaultRules))
      ..add(DiagnosticsProperty('replies', replies))
      ..add(DiagnosticsProperty('auth', auth))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('selectedDate', selectedDate))
      ..add(DiagnosticsProperty('selectedGroupId', selectedGroupId))
      ..add(DiagnosticsProperty('selectedScheduleId', selectedScheduleId))
      ..add(DiagnosticsProperty('locale', locale))
      ..add(DiagnosticsProperty('hasSeenFeedbackCard', hasSeenFeedbackCard));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppState &&
            (identical(other.profiles, profiles) ||
                other.profiles == profiles) &&
            (identical(other.groups, groups) || other.groups == groups) &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.invites, invites) || other.invites == invites) &&
            (identical(other.schedules, schedules) ||
                other.schedules == schedules) &&
            (identical(other.defaultRules, defaultRules) ||
                other.defaultRules == defaultRules) &&
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
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.hasSeenFeedbackCard, hasSeenFeedbackCard) ||
                other.hasSeenFeedbackCard == hasSeenFeedbackCard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profiles,
      groups,
      members,
      invites,
      schedules,
      defaultRules,
      replies,
      auth,
      themeMode,
      selectedDate,
      selectedGroupId,
      selectedScheduleId,
      locale,
      hasSeenFeedbackCard);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(profiles: $profiles, groups: $groups, members: $members, invites: $invites, schedules: $schedules, defaultRules: $defaultRules, replies: $replies, auth: $auth, themeMode: $themeMode, selectedDate: $selectedDate, selectedGroupId: $selectedGroupId, selectedScheduleId: $selectedScheduleId, locale: $locale, hasSeenFeedbackCard: $hasSeenFeedbackCard)';
  }
}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) =
      _$AppStateCopyWithImpl;
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Member> members,
      RemoteEntityState<Invite> invites,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultRule> defaultRules,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      DateTime selectedDate,
      String? selectedGroupId,
      String? selectedScheduleId,
      LocaleState? locale,
      bool? hasSeenFeedbackCard});

  $AuthStateCopyWith<$Res> get auth;
  $LocaleStateCopyWith<$Res>? get locale;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

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
    Object? defaultRules = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? selectedDate = null,
    Object? selectedGroupId = freezed,
    Object? selectedScheduleId = freezed,
    Object? locale = freezed,
    Object? hasSeenFeedbackCard = freezed,
  }) {
    return _then(_self.copyWith(
      profiles: null == profiles
          ? _self.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Profile>,
      groups: null == groups
          ? _self.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Group>,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Member>,
      invites: null == invites
          ? _self.invites
          : invites // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Invite>,
      schedules: null == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Schedule>,
      defaultRules: null == defaultRules
          ? _self.defaultRules
          : defaultRules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<DefaultRule>,
      replies: null == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Reply>,
      auth: null == auth
          ? _self.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as AuthState,
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedGroupId: freezed == selectedGroupId
          ? _self.selectedGroupId
          : selectedGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedScheduleId: freezed == selectedScheduleId
          ? _self.selectedScheduleId
          : selectedScheduleId // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState?,
      hasSeenFeedbackCard: freezed == hasSeenFeedbackCard
          ? _self.hasSeenFeedbackCard
          : hasSeenFeedbackCard // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<$Res> get auth {
    return $AuthStateCopyWith<$Res>(_self.auth, (value) {
      return _then(_self.copyWith(auth: value));
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocaleStateCopyWith<$Res>? get locale {
    if (_self.locale == null) {
      return null;
    }

    return $LocaleStateCopyWith<$Res>(_self.locale!, (value) {
      return _then(_self.copyWith(locale: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AppState].
extension AppStatePatterns on AppState {
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
    TResult Function(_AppState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppState() when $default != null:
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
    TResult Function(_AppState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppState():
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
    TResult? Function(_AppState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppState() when $default != null:
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
            RemoteEntityState<Profile> profiles,
            RemoteEntityState<Group> groups,
            RemoteEntityState<Member> members,
            RemoteEntityState<Invite> invites,
            RemoteEntityState<Schedule> schedules,
            RemoteEntityState<DefaultRule> defaultRules,
            RemoteEntityState<Reply> replies,
            AuthState auth,
            ThemeMode themeMode,
            DateTime selectedDate,
            String? selectedGroupId,
            String? selectedScheduleId,
            LocaleState? locale,
            bool? hasSeenFeedbackCard)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppState() when $default != null:
        return $default(
            _that.profiles,
            _that.groups,
            _that.members,
            _that.invites,
            _that.schedules,
            _that.defaultRules,
            _that.replies,
            _that.auth,
            _that.themeMode,
            _that.selectedDate,
            _that.selectedGroupId,
            _that.selectedScheduleId,
            _that.locale,
            _that.hasSeenFeedbackCard);
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
            RemoteEntityState<Profile> profiles,
            RemoteEntityState<Group> groups,
            RemoteEntityState<Member> members,
            RemoteEntityState<Invite> invites,
            RemoteEntityState<Schedule> schedules,
            RemoteEntityState<DefaultRule> defaultRules,
            RemoteEntityState<Reply> replies,
            AuthState auth,
            ThemeMode themeMode,
            DateTime selectedDate,
            String? selectedGroupId,
            String? selectedScheduleId,
            LocaleState? locale,
            bool? hasSeenFeedbackCard)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppState():
        return $default(
            _that.profiles,
            _that.groups,
            _that.members,
            _that.invites,
            _that.schedules,
            _that.defaultRules,
            _that.replies,
            _that.auth,
            _that.themeMode,
            _that.selectedDate,
            _that.selectedGroupId,
            _that.selectedScheduleId,
            _that.locale,
            _that.hasSeenFeedbackCard);
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
            RemoteEntityState<Profile> profiles,
            RemoteEntityState<Group> groups,
            RemoteEntityState<Member> members,
            RemoteEntityState<Invite> invites,
            RemoteEntityState<Schedule> schedules,
            RemoteEntityState<DefaultRule> defaultRules,
            RemoteEntityState<Reply> replies,
            AuthState auth,
            ThemeMode themeMode,
            DateTime selectedDate,
            String? selectedGroupId,
            String? selectedScheduleId,
            LocaleState? locale,
            bool? hasSeenFeedbackCard)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppState() when $default != null:
        return $default(
            _that.profiles,
            _that.groups,
            _that.members,
            _that.invites,
            _that.schedules,
            _that.defaultRules,
            _that.replies,
            _that.auth,
            _that.themeMode,
            _that.selectedDate,
            _that.selectedGroupId,
            _that.selectedScheduleId,
            _that.locale,
            _that.hasSeenFeedbackCard);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppState with DiagnosticableTreeMixin implements AppState {
  const _AppState(
      {this.profiles = const RemoteEntityState<Profile>(),
      this.groups = const RemoteEntityState<Group>(),
      this.members = const RemoteEntityState<Member>(),
      this.invites = const RemoteEntityState<Invite>(),
      this.schedules = const RemoteEntityState<Schedule>(),
      this.defaultRules = const RemoteEntityState<DefaultRule>(),
      this.replies = const RemoteEntityState<Reply>(),
      this.auth = const AuthState(status: AuthStatus.initial),
      this.themeMode = ThemeMode.system,
      required this.selectedDate,
      this.selectedGroupId,
      this.selectedScheduleId,
      this.locale,
      this.hasSeenFeedbackCard});
  factory _AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

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
  final RemoteEntityState<DefaultRule> defaultRules;
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
  final bool? hasSeenFeedbackCard;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppStateCopyWith<_AppState> get copyWith =>
      __$AppStateCopyWithImpl<_AppState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppStateToJson(
      this,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'AppState'))
      ..add(DiagnosticsProperty('profiles', profiles))
      ..add(DiagnosticsProperty('groups', groups))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('invites', invites))
      ..add(DiagnosticsProperty('schedules', schedules))
      ..add(DiagnosticsProperty('defaultRules', defaultRules))
      ..add(DiagnosticsProperty('replies', replies))
      ..add(DiagnosticsProperty('auth', auth))
      ..add(DiagnosticsProperty('themeMode', themeMode))
      ..add(DiagnosticsProperty('selectedDate', selectedDate))
      ..add(DiagnosticsProperty('selectedGroupId', selectedGroupId))
      ..add(DiagnosticsProperty('selectedScheduleId', selectedScheduleId))
      ..add(DiagnosticsProperty('locale', locale))
      ..add(DiagnosticsProperty('hasSeenFeedbackCard', hasSeenFeedbackCard));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppState &&
            (identical(other.profiles, profiles) ||
                other.profiles == profiles) &&
            (identical(other.groups, groups) || other.groups == groups) &&
            (identical(other.members, members) || other.members == members) &&
            (identical(other.invites, invites) || other.invites == invites) &&
            (identical(other.schedules, schedules) ||
                other.schedules == schedules) &&
            (identical(other.defaultRules, defaultRules) ||
                other.defaultRules == defaultRules) &&
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
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.hasSeenFeedbackCard, hasSeenFeedbackCard) ||
                other.hasSeenFeedbackCard == hasSeenFeedbackCard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      profiles,
      groups,
      members,
      invites,
      schedules,
      defaultRules,
      replies,
      auth,
      themeMode,
      selectedDate,
      selectedGroupId,
      selectedScheduleId,
      locale,
      hasSeenFeedbackCard);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppState(profiles: $profiles, groups: $groups, members: $members, invites: $invites, schedules: $schedules, defaultRules: $defaultRules, replies: $replies, auth: $auth, themeMode: $themeMode, selectedDate: $selectedDate, selectedGroupId: $selectedGroupId, selectedScheduleId: $selectedScheduleId, locale: $locale, hasSeenFeedbackCard: $hasSeenFeedbackCard)';
  }
}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) =
      __$AppStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {RemoteEntityState<Profile> profiles,
      RemoteEntityState<Group> groups,
      RemoteEntityState<Member> members,
      RemoteEntityState<Invite> invites,
      RemoteEntityState<Schedule> schedules,
      RemoteEntityState<DefaultRule> defaultRules,
      RemoteEntityState<Reply> replies,
      AuthState auth,
      ThemeMode themeMode,
      DateTime selectedDate,
      String? selectedGroupId,
      String? selectedScheduleId,
      LocaleState? locale,
      bool? hasSeenFeedbackCard});

  @override
  $AuthStateCopyWith<$Res> get auth;
  @override
  $LocaleStateCopyWith<$Res>? get locale;
}

/// @nodoc
class __$AppStateCopyWithImpl<$Res> implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profiles = null,
    Object? groups = null,
    Object? members = null,
    Object? invites = null,
    Object? schedules = null,
    Object? defaultRules = null,
    Object? replies = null,
    Object? auth = null,
    Object? themeMode = null,
    Object? selectedDate = null,
    Object? selectedGroupId = freezed,
    Object? selectedScheduleId = freezed,
    Object? locale = freezed,
    Object? hasSeenFeedbackCard = freezed,
  }) {
    return _then(_AppState(
      profiles: null == profiles
          ? _self.profiles
          : profiles // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Profile>,
      groups: null == groups
          ? _self.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Group>,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Member>,
      invites: null == invites
          ? _self.invites
          : invites // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Invite>,
      schedules: null == schedules
          ? _self.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Schedule>,
      defaultRules: null == defaultRules
          ? _self.defaultRules
          : defaultRules // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<DefaultRule>,
      replies: null == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as RemoteEntityState<Reply>,
      auth: null == auth
          ? _self.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as AuthState,
      themeMode: null == themeMode
          ? _self.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      selectedDate: null == selectedDate
          ? _self.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedGroupId: freezed == selectedGroupId
          ? _self.selectedGroupId
          : selectedGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedScheduleId: freezed == selectedScheduleId
          ? _self.selectedScheduleId
          : selectedScheduleId // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _self.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as LocaleState?,
      hasSeenFeedbackCard: freezed == hasSeenFeedbackCard
          ? _self.hasSeenFeedbackCard
          : hasSeenFeedbackCard // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<$Res> get auth {
    return $AuthStateCopyWith<$Res>(_self.auth, (value) {
      return _then(_self.copyWith(auth: value));
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocaleStateCopyWith<$Res>? get locale {
    if (_self.locale == null) {
      return null;
    }

    return $LocaleStateCopyWith<$Res>(_self.locale!, (value) {
      return _then(_self.copyWith(locale: value));
    });
  }
}

// dart format on
