import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/brick/brick.dart';
import 'package:redux_entity/redux_entity.dart';

import 'auth_state.dart';
import 'locale_state.dart';

part 'app_state.freezed.dart';

@freezed
sealed class AppState with _$AppState {
  const factory AppState({
    @Default(RemoteEntityState<Profile>()) RemoteEntityState<Profile> profiles,
    @Default(RemoteEntityState<Group>()) RemoteEntityState<Group> groups,
    @Default(RemoteEntityState<Member>()) RemoteEntityState<Member> members,
    @Default(RemoteEntityState<Invite>()) RemoteEntityState<Invite> invites,
    @Default(RemoteEntityState<Schedule>())
    RemoteEntityState<Schedule> schedules,
    @Default(RemoteEntityState<DefaultReply>())
    RemoteEntityState<DefaultReply> defaultReplies,
    @Default(RemoteEntityState<Reply>()) RemoteEntityState<Reply> replies,
    @Default(AuthState(status: AuthStatus.initial)) AuthState auth,
    @Default(ThemeMode.system) ThemeMode themeMode,
    required DateTime selectedDate,
    String? selectedGroupId,
    String? selectedScheduleId,
    LocaleState? locale,
  }) = _AppState;

  factory AppState.initialState() => AppState(selectedDate: DateTime.now());
}
