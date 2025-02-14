// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_state.dart';

class AuthStatusMapper extends EnumMapper<AuthStatus> {
  AuthStatusMapper._();

  static AuthStatusMapper? _instance;
  static AuthStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStatusMapper._());
    }
    return _instance!;
  }

  static AuthStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AuthStatus decode(dynamic value) {
    switch (value) {
      case 'initial':
        return AuthStatus.initial;
      case 'authenticated':
        return AuthStatus.authenticated;
      case 'unauthenticated':
        return AuthStatus.unauthenticated;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AuthStatus self) {
    switch (self) {
      case AuthStatus.initial:
        return 'initial';
      case AuthStatus.authenticated:
        return 'authenticated';
      case AuthStatus.unauthenticated:
        return 'unauthenticated';
    }
  }
}

extension AuthStatusMapperExtension on AuthStatus {
  String toValue() {
    AuthStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AuthStatus>(this) as String;
  }
}

class AuthStateMapper extends ClassMapperBase<AuthState> {
  AuthStateMapper._();

  static AuthStateMapper? _instance;
  static AuthStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthStateMapper._());
      MapperContainer.globals.useAll([UserMapper()]);
      AuthStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AuthState';

  static AuthStatus _$status(AuthState v) => v.status;
  static const Field<AuthState, AuthStatus> _f$status =
      Field('status', _$status);
  static User? _$user(AuthState v) => v.user;
  static const Field<AuthState, User> _f$user =
      Field('user', _$user, opt: true);
  static String? _$lastRoute(AuthState v) => v.lastRoute;
  static const Field<AuthState, String> _f$lastRoute =
      Field('lastRoute', _$lastRoute, opt: true);

  @override
  final MappableFields<AuthState> fields = const {
    #status: _f$status,
    #user: _f$user,
    #lastRoute: _f$lastRoute,
  };

  static AuthState _instantiate(DecodingData data) {
    return AuthState(
        status: data.dec(_f$status),
        user: data.dec(_f$user),
        lastRoute: data.dec(_f$lastRoute));
  }

  @override
  final Function instantiate = _instantiate;

  static AuthState fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthState>(map);
  }

  static AuthState fromJsonString(String json) {
    return ensureInitialized().decodeJson<AuthState>(json);
  }
}

mixin AuthStateMappable {
  String toJsonString() {
    return AuthStateMapper.ensureInitialized()
        .encodeJson<AuthState>(this as AuthState);
  }

  Map<String, dynamic> toJson() {
    return AuthStateMapper.ensureInitialized()
        .encodeMap<AuthState>(this as AuthState);
  }

  AuthStateCopyWith<AuthState, AuthState, AuthState> get copyWith =>
      _AuthStateCopyWithImpl(this as AuthState, $identity, $identity);
  @override
  String toString() {
    return AuthStateMapper.ensureInitialized()
        .stringifyValue(this as AuthState);
  }

  @override
  bool operator ==(Object other) {
    return AuthStateMapper.ensureInitialized()
        .equalsValue(this as AuthState, other);
  }

  @override
  int get hashCode {
    return AuthStateMapper.ensureInitialized().hashValue(this as AuthState);
  }
}

extension AuthStateValueCopy<$R, $Out> on ObjectCopyWith<$R, AuthState, $Out> {
  AuthStateCopyWith<$R, AuthState, $Out> get $asAuthState =>
      $base.as((v, t, t2) => _AuthStateCopyWithImpl(v, t, t2));
}

abstract class AuthStateCopyWith<$R, $In extends AuthState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({AuthStatus? status, User? user, String? lastRoute});
  AuthStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AuthStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AuthState, $Out>
    implements AuthStateCopyWith<$R, AuthState, $Out> {
  _AuthStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AuthState> $mapper =
      AuthStateMapper.ensureInitialized();
  @override
  $R call(
          {AuthStatus? status,
          Object? user = $none,
          Object? lastRoute = $none}) =>
      $apply(FieldCopyWithData({
        if (status != null) #status: status,
        if (user != $none) #user: user,
        if (lastRoute != $none) #lastRoute: lastRoute
      }));
  @override
  AuthState $make(CopyWithData data) => AuthState(
      status: data.get(#status, or: $value.status),
      user: data.get(#user, or: $value.user),
      lastRoute: data.get(#lastRoute, or: $value.lastRoute));

  @override
  AuthStateCopyWith<$R2, AuthState, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _AuthStateCopyWithImpl($value, $cast, t);
}
