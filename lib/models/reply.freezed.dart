// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return _Reply.fromJson(json);
}

/// @nodoc
mixin _$Reply {
  int get memberId => throw _privateConstructorUsedError;
  int get scheduleId => throw _privateConstructorUsedError;
  DateTime get instanceDate => throw _privateConstructorUsedError;
  ReplyOptions get selectedOption => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Reply to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReplyCopyWith<Reply> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReplyCopyWith<$Res> {
  factory $ReplyCopyWith(Reply value, $Res Function(Reply) then) =
      _$ReplyCopyWithImpl<$Res, Reply>;
  @useResult
  $Res call(
      {int memberId,
      int scheduleId,
      DateTime instanceDate,
      ReplyOptions selectedOption,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReplyCopyWithImpl<$Res, $Val extends Reply>
    implements $ReplyCopyWith<$Res> {
  _$ReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? scheduleId = null,
    Object? instanceDate = null,
    Object? selectedOption = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedOption: null == selectedOption
          ? _value.selectedOption
          : selectedOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions,
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
abstract class _$$ReplyImplCopyWith<$Res> implements $ReplyCopyWith<$Res> {
  factory _$$ReplyImplCopyWith(
          _$ReplyImpl value, $Res Function(_$ReplyImpl) then) =
      __$$ReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int memberId,
      int scheduleId,
      DateTime instanceDate,
      ReplyOptions selectedOption,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReplyImplCopyWithImpl<$Res>
    extends _$ReplyCopyWithImpl<$Res, _$ReplyImpl>
    implements _$$ReplyImplCopyWith<$Res> {
  __$$ReplyImplCopyWithImpl(
      _$ReplyImpl _value, $Res Function(_$ReplyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? scheduleId = null,
    Object? instanceDate = null,
    Object? selectedOption = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReplyImpl(
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedOption: null == selectedOption
          ? _value.selectedOption
          : selectedOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions,
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
class _$ReplyImpl with DiagnosticableTreeMixin implements _Reply {
  const _$ReplyImpl(
      {required this.memberId,
      required this.scheduleId,
      required this.instanceDate,
      required this.selectedOption,
      this.createdAt,
      this.updatedAt});

  factory _$ReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReplyImplFromJson(json);

  @override
  final int memberId;
  @override
  final int scheduleId;
  @override
  final DateTime instanceDate;
  @override
  final ReplyOptions selectedOption;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Reply(memberId: $memberId, scheduleId: $scheduleId, instanceDate: $instanceDate, selectedOption: $selectedOption, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Reply'))
      ..add(DiagnosticsProperty('memberId', memberId))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('instanceDate', instanceDate))
      ..add(DiagnosticsProperty('selectedOption', selectedOption))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReplyImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            (identical(other.selectedOption, selectedOption) ||
                other.selectedOption == selectedOption) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberId, scheduleId,
      instanceDate, selectedOption, createdAt, updatedAt);

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      __$$ReplyImplCopyWithImpl<_$ReplyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReplyImplToJson(
      this,
    );
  }
}

abstract class _Reply implements Reply {
  const factory _Reply(
      {required final int memberId,
      required final int scheduleId,
      required final DateTime instanceDate,
      required final ReplyOptions selectedOption,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ReplyImpl;

  factory _Reply.fromJson(Map<String, dynamic> json) = _$ReplyImpl.fromJson;

  @override
  int get memberId;
  @override
  int get scheduleId;
  @override
  DateTime get instanceDate;
  @override
  ReplyOptions get selectedOption;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Reply
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReplyImplCopyWith<_$ReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
