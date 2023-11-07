// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'root_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RootStateImpl _$$RootStateImplFromJson(Map<String, dynamic> json) =>
    _$RootStateImpl(
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
      locale: json['locale'] == null
          ? const LocaleState(languageCode: 'und')
          : LocaleState.fromJson(json['locale'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RootStateImplToJson(_$RootStateImpl instance) =>
    <String, dynamic>{
      'profiles': instance.profiles,
      'groups': instance.groups,
      'schedules': instance.schedules,
      'defaultReplies': instance.defaultReplies,
      'replies': instance.replies,
      'auth': instance.auth,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'locale': instance.locale,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
