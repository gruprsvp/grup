// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppStateImpl _$$AppStateImplFromJson(Map<String, dynamic> json) =>
    _$AppStateImpl(
      profiles: json['profiles'] == null
          ? const RemoteEntityState<Profile>()
          : RemoteEntityState<Profile>.fromJson(
              json['profiles'] as Map<String, dynamic>,
              (value) => Profile.fromJson(value as Map<String, dynamic>)),
      groups: json['groups'] == null
          ? const RemoteEntityState<Group>()
          : RemoteEntityState<Group>.fromJson(
              json['groups'] as Map<String, dynamic>,
              (value) => Group.fromJson(value as Map<String, dynamic>)),
      members: json['members'] == null
          ? const RemoteEntityState<Member>()
          : RemoteEntityState<Member>.fromJson(
              json['members'] as Map<String, dynamic>,
              (value) => Member.fromJson(value as Map<String, dynamic>)),
      invites: json['invites'] == null
          ? const RemoteEntityState<Invite>()
          : RemoteEntityState<Invite>.fromJson(
              json['invites'] as Map<String, dynamic>,
              (value) => Invite.fromJson(value as Map<String, dynamic>)),
      schedules: json['schedules'] == null
          ? const RemoteEntityState<Schedule>()
          : RemoteEntityState<Schedule>.fromJson(
              json['schedules'] as Map<String, dynamic>,
              (value) => Schedule.fromJson(value as Map<String, dynamic>)),
      defaultReplies: json['defaultReplies'] == null
          ? const RemoteEntityState<DefaultReply>()
          : RemoteEntityState<DefaultReply>.fromJson(
              json['defaultReplies'] as Map<String, dynamic>,
              (value) => DefaultReply.fromJson(value as Map<String, dynamic>)),
      replies: json['replies'] == null
          ? const RemoteEntityState<Reply>()
          : RemoteEntityState<Reply>.fromJson(
              json['replies'] as Map<String, dynamic>,
              (value) => Reply.fromJson(value as Map<String, dynamic>)),
      auth: json['auth'] == null
          ? const AuthState(status: AuthStatus.initial)
          : AuthState.fromJson(json['auth'] as Map<String, dynamic>),
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      selectedDate: DateTime.parse(json['selectedDate'] as String),
      selectedGroupId: json['selectedGroupId'] as String?,
      locale: json['locale'] == null
          ? null
          : LocaleState.fromJson(json['locale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppStateImplToJson(_$AppStateImpl instance) =>
    <String, dynamic>{
      'profiles': instance.profiles,
      'groups': instance.groups,
      'members': instance.members,
      'invites': instance.invites,
      'schedules': instance.schedules,
      'defaultReplies': instance.defaultReplies,
      'replies': instance.replies,
      'auth': instance.auth,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'selectedDate': instance.selectedDate.toIso8601String(),
      'selectedGroupId': instance.selectedGroupId,
      'locale': instance.locale,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
