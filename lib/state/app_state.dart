import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:parousia/brick/brick.dart';
import 'package:redux_entity/redux_entity.dart';

import 'auth_state.dart';
import 'locale_state.dart';

part 'app_state.mapper.dart';

@MappableClass(
    discriminatorKey: 'type',
    includeCustomMappers: [ThemeModeMapper(), RemoteEntityStateMapper()])
class AppState with AppStateMappable {
  final RemoteEntityState<Profile> profiles;
  final RemoteEntityState<Group> groups;
  final RemoteEntityState<Member> members;
  final RemoteEntityState<Invite> invites;
  final RemoteEntityState<Schedule> schedules;
  final RemoteEntityState<DefaultRule> defaultRules;
  final RemoteEntityState<Reply> replies;
  final AuthState auth;
  final ThemeMode themeMode;
  final DateTime selectedDate;
  final String? selectedGroupId;
  final String? selectedScheduleId;
  final LocaleState? locale;
  final bool? hasSeenFeedbackCard;

  AppState({
    this.profiles = const RemoteEntityState<Profile>(),
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
    this.hasSeenFeedbackCard,
  });

  @MappableClass(discriminatorValue: 'initialState')
  factory AppState.initialState() => AppState(selectedDate: DateTime.now());

  /// When loading the state from the database, set today's date
  @MappableClass(discriminatorValue: 'copyWithSelectedDateToday')
  factory AppState.copyWithSelectedDateToday(AppState? state) =>
      state?.copyWith(selectedDate: DateTime.now()) ?? AppState.initialState();

  /// Copy the state without the errors, to avoid persisting them
  @MappableClass(discriminatorValue: 'copyWithoutErrors')
  factory AppState.copyWithoutErrors(AppState? state) =>
      state?.copyWith(
        profiles: state.profiles.copyWith(error: null),
        groups: state.groups.copyWith(error: null),
        members: state.members.copyWith(error: null),
        schedules: state.schedules.copyWith(error: null),
        replies: state.replies.copyWith(error: null),
        invites: state.invites.copyWith(error: null),
      ) ??
      AppState.initialState();

  static final fromJson = AppStateMapper.fromJson;
}

class ThemeModeMapper extends SimpleMapper<ThemeMode> {
  const ThemeModeMapper();

  @override
  ThemeMode decode(dynamic value) {
    switch (value) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        throw FormatException('Invalid ThemeMode: $value');
    }
  }

  @override
  dynamic encode(ThemeMode self) {
    return self.toString();
  }
}

class RemoteEntityStateMapper extends SimpleMapper1<RemoteEntityState> {
  const RemoteEntityStateMapper();

  @override
  // use the type parameter [T] in the return type [GenericBox<T>]
  RemoteEntityState<T> decode<T>(dynamic value) {
    // use the type parameter [T] in your decoding logic
    T content = container.fromValue<T>(value);
    return RemoteEntityState<T>.fromJson(value, (json) => T.fromJson(json));
  }

  @override
  // use the type parameter [T] in the parameter type [GenericBox<T>]
  dynamic encode<T>(RemoteEntityState<T> self) {
    return self.toJson();
  }

  // In case of generic types, we also must specify a type factory. This is a special type of
  // function used internally to construct generic instances of your type.
  // Specify any type arguments in alignment to the decode/encode functions.
  @override
  Function get typeFactory => <T>(f) => f<RemoteEntityState<T>>();
}

extension on Type {
  Deserializer get fromJson => (dynamic json) => throw UnimplementedError();
}
