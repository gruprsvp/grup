// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Role _$RoleFromJson(Map<String, dynamic> json) {
  return _Role.fromJson(json);
}

/// @nodoc
mixin _$Role {
  int get id => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get canManageGroup => throw _privateConstructorUsedError;
  bool get canManageMembers => throw _privateConstructorUsedError;
  bool get canManageInvites => throw _privateConstructorUsedError;
  bool get canManageSchedules => throw _privateConstructorUsedError;
  bool get canManageReplies => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoleCopyWith<Role> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleCopyWith<$Res> {
  factory $RoleCopyWith(Role value, $Res Function(Role) then) =
      _$RoleCopyWithImpl<$Res, Role>;
  @useResult
  $Res call(
      {int id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String displayName,
      bool canManageGroup,
      bool canManageMembers,
      bool canManageInvites,
      bool canManageSchedules,
      bool canManageReplies});
}

/// @nodoc
class _$RoleCopyWithImpl<$Res, $Val extends Role>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? displayName = null,
    Object? canManageGroup = null,
    Object? canManageMembers = null,
    Object? canManageInvites = null,
    Object? canManageSchedules = null,
    Object? canManageReplies = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      canManageGroup: null == canManageGroup
          ? _value.canManageGroup
          : canManageGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageMembers: null == canManageMembers
          ? _value.canManageMembers
          : canManageMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageInvites: null == canManageInvites
          ? _value.canManageInvites
          : canManageInvites // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageSchedules: null == canManageSchedules
          ? _value.canManageSchedules
          : canManageSchedules // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageReplies: null == canManageReplies
          ? _value.canManageReplies
          : canManageReplies // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleImplCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$$RoleImplCopyWith(
          _$RoleImpl value, $Res Function(_$RoleImpl) then) =
      __$$RoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String displayName,
      bool canManageGroup,
      bool canManageMembers,
      bool canManageInvites,
      bool canManageSchedules,
      bool canManageReplies});
}

/// @nodoc
class __$$RoleImplCopyWithImpl<$Res>
    extends _$RoleCopyWithImpl<$Res, _$RoleImpl>
    implements _$$RoleImplCopyWith<$Res> {
  __$$RoleImplCopyWithImpl(_$RoleImpl _value, $Res Function(_$RoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? displayName = null,
    Object? canManageGroup = null,
    Object? canManageMembers = null,
    Object? canManageInvites = null,
    Object? canManageSchedules = null,
    Object? canManageReplies = null,
  }) {
    return _then(_$RoleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      canManageGroup: null == canManageGroup
          ? _value.canManageGroup
          : canManageGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageMembers: null == canManageMembers
          ? _value.canManageMembers
          : canManageMembers // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageInvites: null == canManageInvites
          ? _value.canManageInvites
          : canManageInvites // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageSchedules: null == canManageSchedules
          ? _value.canManageSchedules
          : canManageSchedules // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageReplies: null == canManageReplies
          ? _value.canManageReplies
          : canManageReplies // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RoleImpl with DiagnosticableTreeMixin implements _Role {
  const _$RoleImpl(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.displayName,
      required this.canManageGroup,
      required this.canManageMembers,
      required this.canManageInvites,
      required this.canManageSchedules,
      required this.canManageReplies});

  factory _$RoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String displayName;
  @override
  final bool canManageGroup;
  @override
  final bool canManageMembers;
  @override
  final bool canManageInvites;
  @override
  final bool canManageSchedules;
  @override
  final bool canManageReplies;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Role(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, displayName: $displayName, canManageGroup: $canManageGroup, canManageMembers: $canManageMembers, canManageInvites: $canManageInvites, canManageSchedules: $canManageSchedules, canManageReplies: $canManageReplies)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Role'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('canManageGroup', canManageGroup))
      ..add(DiagnosticsProperty('canManageMembers', canManageMembers))
      ..add(DiagnosticsProperty('canManageInvites', canManageInvites))
      ..add(DiagnosticsProperty('canManageSchedules', canManageSchedules))
      ..add(DiagnosticsProperty('canManageReplies', canManageReplies));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.canManageGroup, canManageGroup) ||
                other.canManageGroup == canManageGroup) &&
            (identical(other.canManageMembers, canManageMembers) ||
                other.canManageMembers == canManageMembers) &&
            (identical(other.canManageInvites, canManageInvites) ||
                other.canManageInvites == canManageInvites) &&
            (identical(other.canManageSchedules, canManageSchedules) ||
                other.canManageSchedules == canManageSchedules) &&
            (identical(other.canManageReplies, canManageReplies) ||
                other.canManageReplies == canManageReplies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      displayName,
      canManageGroup,
      canManageMembers,
      canManageInvites,
      canManageSchedules,
      canManageReplies);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      __$$RoleImplCopyWithImpl<_$RoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleImplToJson(
      this,
    );
  }
}

abstract class _Role implements Role {
  const factory _Role(
      {required final int id,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      required final String displayName,
      required final bool canManageGroup,
      required final bool canManageMembers,
      required final bool canManageInvites,
      required final bool canManageSchedules,
      required final bool canManageReplies}) = _$RoleImpl;

  factory _Role.fromJson(Map<String, dynamic> json) = _$RoleImpl.fromJson;

  @override
  int get id;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String get displayName;
  @override
  bool get canManageGroup;
  @override
  bool get canManageMembers;
  @override
  bool get canManageInvites;
  @override
  bool get canManageSchedules;
  @override
  bool get canManageReplies;
  @override
  @JsonKey(ignore: true)
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
