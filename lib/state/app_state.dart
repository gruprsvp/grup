import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:redux_entity/redux_entity.dart';

import 'auth_state.dart';
import 'locale_state.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState({
    @Default(RemoteEntityState<Profile>()) RemoteEntityState<Profile> profiles,
    @Default(RemoteEntityState<Group>()) RemoteEntityState<Group> groups,
    @Default(RemoteEntityState<Member>()) RemoteEntityState<Member> members,
    @Default(RemoteEntityState<Invite>()) RemoteEntityState<Invite> invites,
    @Default(RemoteEntityState<Schedule>())
    RemoteEntityState<Schedule> schedules,
    @Default(RemoteEntityState<DefaultRule>())
    RemoteEntityState<DefaultRule> defaultRules,
    @Default(RemoteEntityState<Reply>()) RemoteEntityState<Reply> replies,
    @Default(AuthState(status: AuthStatus.initial)) AuthState auth,
    @Default(ThemeMode.system) ThemeMode themeMode,
    required DateTime selectedDate,
    String? selectedGroupId,
    String? selectedScheduleId,
    LocaleState? locale,
    bool? hasSeenFeedbackCard,
  }) = _AppState;

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

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
