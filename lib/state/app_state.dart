import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:parousia/brick/brick.dart';
import 'package:redux_entity/redux_entity.dart';

import 'auth_state.dart';
import 'locale_state.dart';

part 'app_state.mapper.dart';

@MappableClass()
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

  factory AppState.initialState() => AppState(selectedDate: DateTime.now());

  /// When loading the state from the database, set today's date
  factory AppState.copyWithSelectedDateToday(AppState? state) =>
      state?.copyWith(selectedDate: DateTime.now()) ?? AppState.initialState();

  /// Copy the state without the errors, to avoid persisting them
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
