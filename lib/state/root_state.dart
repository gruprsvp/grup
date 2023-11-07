import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:parousia/models/models.dart';
import 'package:redux_entity/redux_entity.dart';

import 'auth_state.dart';
import 'locale_state.dart';

part 'root_state.freezed.dart';
part 'root_state.g.dart';

@freezed
sealed class RootState with _$RootState {
  const factory RootState({
    @Default(RemoteEntityState<Profile>()) RemoteEntityState<Profile> profiles,
    @Default(RemoteEntityState<Group>()) RemoteEntityState<Group> groups,
    @Default(RemoteEntityState<Schedule>())
    RemoteEntityState<Schedule> schedules,
    @Default(RemoteEntityState<DefaultReply>())
    RemoteEntityState<DefaultReply> defaultReplies,
    @Default(RemoteEntityState<Reply>()) RemoteEntityState<Reply> replies,
    @Default(AuthState(status: AuthStatus.initial)) AuthState auth,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(LocaleState(languageCode: 'und')) LocaleState locale,
  }) = _RootState;

  factory RootState.initialState() => const RootState();

  factory RootState.fromJson(Map<String, dynamic> json) =>
      _$RootStateFromJson(json);
}
