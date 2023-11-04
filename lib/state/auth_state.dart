import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase/supabase.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    @UserJsonConverter() User? user,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);
}

/// Converts a [User] object to and from JSON.
class UserJsonConverter extends JsonConverter<User, Map<String, dynamic>> {
  const UserJsonConverter();

  @override
  User fromJson(Map<String, dynamic> json) {
    final user = User.fromJson(json);
    if (user == null) {
      throw const FormatException('invalid user');
    }
    return user;
  }

  @override
  Map<String, dynamic> toJson(User object) => object.toJson();
}
