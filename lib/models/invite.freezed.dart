// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Invite _$InviteFromJson(Map<String, dynamic> json) {
  return _Invite.fromJson(json);
}

/// @nodoc
mixin _$Invite {
  int get id => throw _privateConstructorUsedError;
  int get memberId => throw _privateConstructorUsedError;
  InviteMethods get method => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Invite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Invite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteCopyWith<Invite> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteCopyWith<$Res> {
  factory $InviteCopyWith(Invite value, $Res Function(Invite) then) =
      _$InviteCopyWithImpl<$Res, Invite>;
  @useResult
  $Res call(
      {int id,
      int memberId,
      InviteMethods method,
      String value,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$InviteCopyWithImpl<$Res, $Val extends Invite>
    implements $InviteCopyWith<$Res> {
  _$InviteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? method = null,
    Object? value = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as InviteMethods,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteImplCopyWith<$Res> implements $InviteCopyWith<$Res> {
  factory _$$InviteImplCopyWith(
          _$InviteImpl value, $Res Function(_$InviteImpl) then) =
      __$$InviteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int memberId,
      InviteMethods method,
      String value,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$InviteImplCopyWithImpl<$Res>
    extends _$InviteCopyWithImpl<$Res, _$InviteImpl>
    implements _$$InviteImplCopyWith<$Res> {
  __$$InviteImplCopyWithImpl(
      _$InviteImpl _value, $Res Function(_$InviteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memberId = null,
    Object? method = null,
    Object? value = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InviteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as InviteMethods,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$InviteImpl with DiagnosticableTreeMixin implements _Invite {
  const _$InviteImpl(
      {required this.id,
      required this.memberId,
      required this.method,
      required this.value,
      this.createdAt,
      this.updatedAt});

  factory _$InviteImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteImplFromJson(json);

  @override
  final int id;
  @override
  final int memberId;
  @override
  final InviteMethods method;
  @override
  final String value;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Invite(id: $id, memberId: $memberId, method: $method, value: $value, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Invite'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('memberId', memberId))
      ..add(DiagnosticsProperty('method', method))
      ..add(DiagnosticsProperty('value', value))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, memberId, method, value, createdAt, updatedAt);

  /// Create a copy of Invite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteImplCopyWith<_$InviteImpl> get copyWith =>
      __$$InviteImplCopyWithImpl<_$InviteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteImplToJson(
      this,
    );
  }
}

abstract class _Invite implements Invite {
  const factory _Invite(
      {required final int id,
      required final int memberId,
      required final InviteMethods method,
      required final String value,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$InviteImpl;

  factory _Invite.fromJson(Map<String, dynamic> json) = _$InviteImpl.fromJson;

  @override
  int get id;
  @override
  int get memberId;
  @override
  InviteMethods get method;
  @override
  String get value;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Invite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteImplCopyWith<_$InviteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
