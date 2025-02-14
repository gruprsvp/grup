import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/foundation.dart'; // ignore: unused_import
import 'package:supabase/supabase.dart';

part 'auth_state.mapper.dart';

@MappableEnum()
enum AuthStatus { initial, authenticated, unauthenticated }

@MappableClass(includeCustomMappers: [UserMapper()])
class AuthState with AuthStateMappable {
  final AuthStatus status;
  final User? user;
  final String? lastRoute;

  const AuthState({required this.status, this.user, this.lastRoute});

  static final fromJson = AuthStateMapper.fromJson;
}

/// Converts a [User] object to and from JSON.
class UserMapper extends SimpleMapper<User> {
  const UserMapper();

  @override
  User decode(dynamic value) {
    final user = User.fromJson(value);
    if (user == null) {
      throw const FormatException('invalid user');
    }
    return user;
  }

  @override
  dynamic encode(User self) {
    return self.toJson();
  }
}
