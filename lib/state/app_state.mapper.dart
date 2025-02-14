// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'app_state.dart';

class AppStateMapper extends ClassMapperBase<AppState> {
  AppStateMapper._();

  static AppStateMapper? _instance;
  static AppStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AppStateMapper._());
      MapperContainer.globals
          .useAll([ThemeModeMapper(), RemoteEntityStateMapper()]);
      ProfileMapper.ensureInitialized();
      GroupMapper.ensureInitialized();
      MemberMapper.ensureInitialized();
      ScheduleMapper.ensureInitialized();
      DefaultRuleMapper.ensureInitialized();
      ReplyMapper.ensureInitialized();
      AuthStateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AppState';

  static RemoteEntityState<Profile> _$profiles(AppState v) => v.profiles;
  static const Field<AppState, RemoteEntityState<Profile>> _f$profiles = Field(
      'profiles', _$profiles,
      opt: true, def: const RemoteEntityState<Profile>());
  static RemoteEntityState<Group> _$groups(AppState v) => v.groups;
  static const Field<AppState, RemoteEntityState<Group>> _f$groups = Field(
      'groups', _$groups,
      opt: true, def: const RemoteEntityState<Group>());
  static RemoteEntityState<Member> _$members(AppState v) => v.members;
  static const Field<AppState, RemoteEntityState<Member>> _f$members = Field(
      'members', _$members,
      opt: true, def: const RemoteEntityState<Member>());
  static RemoteEntityState<Invite> _$invites(AppState v) => v.invites;
  static const Field<AppState, RemoteEntityState<Invite>> _f$invites = Field(
      'invites', _$invites,
      opt: true, def: const RemoteEntityState<Invite>());
  static RemoteEntityState<Schedule> _$schedules(AppState v) => v.schedules;
  static const Field<AppState, RemoteEntityState<Schedule>> _f$schedules =
      Field('schedules', _$schedules,
          opt: true, def: const RemoteEntityState<Schedule>());
  static RemoteEntityState<DefaultRule> _$defaultRules(AppState v) =>
      v.defaultRules;
  static const Field<AppState, RemoteEntityState<DefaultRule>> _f$defaultRules =
      Field('defaultRules', _$defaultRules,
          opt: true, def: const RemoteEntityState<DefaultRule>());
  static RemoteEntityState<Reply> _$replies(AppState v) => v.replies;
  static const Field<AppState, RemoteEntityState<Reply>> _f$replies = Field(
      'replies', _$replies,
      opt: true, def: const RemoteEntityState<Reply>());
  static AuthState _$auth(AppState v) => v.auth;
  static const Field<AppState, AuthState> _f$auth = Field('auth', _$auth,
      opt: true, def: const AuthState(status: AuthStatus.initial));
  static ThemeMode _$themeMode(AppState v) => v.themeMode;
  static const Field<AppState, ThemeMode> _f$themeMode =
      Field('themeMode', _$themeMode, opt: true, def: ThemeMode.system);
  static DateTime _$selectedDate(AppState v) => v.selectedDate;
  static const Field<AppState, DateTime> _f$selectedDate =
      Field('selectedDate', _$selectedDate);
  static String? _$selectedGroupId(AppState v) => v.selectedGroupId;
  static const Field<AppState, String> _f$selectedGroupId =
      Field('selectedGroupId', _$selectedGroupId, opt: true);
  static String? _$selectedScheduleId(AppState v) => v.selectedScheduleId;
  static const Field<AppState, String> _f$selectedScheduleId =
      Field('selectedScheduleId', _$selectedScheduleId, opt: true);
  static LocaleState? _$locale(AppState v) => v.locale;
  static const Field<AppState, LocaleState> _f$locale =
      Field('locale', _$locale, opt: true);
  static bool? _$hasSeenFeedbackCard(AppState v) => v.hasSeenFeedbackCard;
  static const Field<AppState, bool> _f$hasSeenFeedbackCard =
      Field('hasSeenFeedbackCard', _$hasSeenFeedbackCard, opt: true);

  @override
  final MappableFields<AppState> fields = const {
    #profiles: _f$profiles,
    #groups: _f$groups,
    #members: _f$members,
    #invites: _f$invites,
    #schedules: _f$schedules,
    #defaultRules: _f$defaultRules,
    #replies: _f$replies,
    #auth: _f$auth,
    #themeMode: _f$themeMode,
    #selectedDate: _f$selectedDate,
    #selectedGroupId: _f$selectedGroupId,
    #selectedScheduleId: _f$selectedScheduleId,
    #locale: _f$locale,
    #hasSeenFeedbackCard: _f$hasSeenFeedbackCard,
  };

  static AppState _instantiate(DecodingData data) {
    return AppState(
        profiles: data.dec(_f$profiles),
        groups: data.dec(_f$groups),
        members: data.dec(_f$members),
        invites: data.dec(_f$invites),
        schedules: data.dec(_f$schedules),
        defaultRules: data.dec(_f$defaultRules),
        replies: data.dec(_f$replies),
        auth: data.dec(_f$auth),
        themeMode: data.dec(_f$themeMode),
        selectedDate: data.dec(_f$selectedDate),
        selectedGroupId: data.dec(_f$selectedGroupId),
        selectedScheduleId: data.dec(_f$selectedScheduleId),
        locale: data.dec(_f$locale),
        hasSeenFeedbackCard: data.dec(_f$hasSeenFeedbackCard));
  }

  @override
  final Function instantiate = _instantiate;

  static AppState fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AppState>(map);
  }

  static AppState fromJsonString(String json) {
    return ensureInitialized().decodeJson<AppState>(json);
  }
}

mixin AppStateMappable {
  String toJsonString() {
    return AppStateMapper.ensureInitialized()
        .encodeJson<AppState>(this as AppState);
  }

  Map<String, dynamic> toJson() {
    return AppStateMapper.ensureInitialized()
        .encodeMap<AppState>(this as AppState);
  }

  AppStateCopyWith<AppState, AppState, AppState> get copyWith =>
      _AppStateCopyWithImpl(this as AppState, $identity, $identity);
  @override
  String toString() {
    return AppStateMapper.ensureInitialized().stringifyValue(this as AppState);
  }

  @override
  bool operator ==(Object other) {
    return AppStateMapper.ensureInitialized()
        .equalsValue(this as AppState, other);
  }

  @override
  int get hashCode {
    return AppStateMapper.ensureInitialized().hashValue(this as AppState);
  }
}

extension AppStateValueCopy<$R, $Out> on ObjectCopyWith<$R, AppState, $Out> {
  AppStateCopyWith<$R, AppState, $Out> get $asAppState =>
      $base.as((v, t, t2) => _AppStateCopyWithImpl(v, t, t2));
}

abstract class AppStateCopyWith<$R, $In extends AppState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AuthStateCopyWith<$R, AuthState, AuthState> get auth;
  $R call(
      {RemoteEntityState<Profile>? profiles,
      RemoteEntityState<Group>? groups,
      RemoteEntityState<Member>? members,
      RemoteEntityState<Invite>? invites,
      RemoteEntityState<Schedule>? schedules,
      RemoteEntityState<DefaultRule>? defaultRules,
      RemoteEntityState<Reply>? replies,
      AuthState? auth,
      ThemeMode? themeMode,
      DateTime? selectedDate,
      String? selectedGroupId,
      String? selectedScheduleId,
      LocaleState? locale,
      bool? hasSeenFeedbackCard});
  AppStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AppStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AppState, $Out>
    implements AppStateCopyWith<$R, AppState, $Out> {
  _AppStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AppState> $mapper =
      AppStateMapper.ensureInitialized();
  @override
  AuthStateCopyWith<$R, AuthState, AuthState> get auth =>
      $value.auth.copyWith.$chain((v) => call(auth: v));
  @override
  $R call(
          {RemoteEntityState<Profile>? profiles,
          RemoteEntityState<Group>? groups,
          RemoteEntityState<Member>? members,
          RemoteEntityState<Invite>? invites,
          RemoteEntityState<Schedule>? schedules,
          RemoteEntityState<DefaultRule>? defaultRules,
          RemoteEntityState<Reply>? replies,
          AuthState? auth,
          ThemeMode? themeMode,
          DateTime? selectedDate,
          Object? selectedGroupId = $none,
          Object? selectedScheduleId = $none,
          Object? locale = $none,
          Object? hasSeenFeedbackCard = $none}) =>
      $apply(FieldCopyWithData({
        if (profiles != null) #profiles: profiles,
        if (groups != null) #groups: groups,
        if (members != null) #members: members,
        if (invites != null) #invites: invites,
        if (schedules != null) #schedules: schedules,
        if (defaultRules != null) #defaultRules: defaultRules,
        if (replies != null) #replies: replies,
        if (auth != null) #auth: auth,
        if (themeMode != null) #themeMode: themeMode,
        if (selectedDate != null) #selectedDate: selectedDate,
        if (selectedGroupId != $none) #selectedGroupId: selectedGroupId,
        if (selectedScheduleId != $none)
          #selectedScheduleId: selectedScheduleId,
        if (locale != $none) #locale: locale,
        if (hasSeenFeedbackCard != $none)
          #hasSeenFeedbackCard: hasSeenFeedbackCard
      }));
  @override
  AppState $make(CopyWithData data) => AppState(
      profiles: data.get(#profiles, or: $value.profiles),
      groups: data.get(#groups, or: $value.groups),
      members: data.get(#members, or: $value.members),
      invites: data.get(#invites, or: $value.invites),
      schedules: data.get(#schedules, or: $value.schedules),
      defaultRules: data.get(#defaultRules, or: $value.defaultRules),
      replies: data.get(#replies, or: $value.replies),
      auth: data.get(#auth, or: $value.auth),
      themeMode: data.get(#themeMode, or: $value.themeMode),
      selectedDate: data.get(#selectedDate, or: $value.selectedDate),
      selectedGroupId: data.get(#selectedGroupId, or: $value.selectedGroupId),
      selectedScheduleId:
          data.get(#selectedScheduleId, or: $value.selectedScheduleId),
      locale: data.get(#locale, or: $value.locale),
      hasSeenFeedbackCard:
          data.get(#hasSeenFeedbackCard, or: $value.hasSeenFeedbackCard));

  @override
  AppStateCopyWith<$R2, AppState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AppStateCopyWithImpl($value, $cast, t);
}
