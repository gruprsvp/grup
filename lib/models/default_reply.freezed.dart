// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'default_reply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DefaultReply _$DefaultReplyFromJson(Map<String, dynamic> json) {
  return _DefaultReply.fromJson(json);
}

/// @nodoc
mixin _$DefaultReply {
  String get id => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  int get memberId => throw _privateConstructorUsedError;
  int get scheduleId => throw _privateConstructorUsedError;
  ReplyOptions get selectedOption => throw _privateConstructorUsedError;
  RecurrenceRule get recurrenceRule => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DefaultReplyCopyWith<DefaultReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefaultReplyCopyWith<$Res> {
  factory $DefaultReplyCopyWith(
          DefaultReply value, $Res Function(DefaultReply) then) =
      _$DefaultReplyCopyWithImpl<$Res, DefaultReply>;
  @useResult
  $Res call(
      {String id,
      DateTime? createdAt,
      DateTime? updatedAt,
      int memberId,
      int scheduleId,
      ReplyOptions selectedOption,
      RecurrenceRule recurrenceRule});
}

/// @nodoc
class _$DefaultReplyCopyWithImpl<$Res, $Val extends DefaultReply>
    implements $DefaultReplyCopyWith<$Res> {
  _$DefaultReplyCopyWithImpl(this._value, this._then);

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
    Object? memberId = null,
    Object? scheduleId = null,
    Object? selectedOption = null,
    Object? recurrenceRule = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedOption: null == selectedOption
          ? _value.selectedOption
          : selectedOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions,
      recurrenceRule: null == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefaultReplyImplCopyWith<$Res>
    implements $DefaultReplyCopyWith<$Res> {
  factory _$$DefaultReplyImplCopyWith(
          _$DefaultReplyImpl value, $Res Function(_$DefaultReplyImpl) then) =
      __$$DefaultReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime? createdAt,
      DateTime? updatedAt,
      int memberId,
      int scheduleId,
      ReplyOptions selectedOption,
      RecurrenceRule recurrenceRule});
}

/// @nodoc
class __$$DefaultReplyImplCopyWithImpl<$Res>
    extends _$DefaultReplyCopyWithImpl<$Res, _$DefaultReplyImpl>
    implements _$$DefaultReplyImplCopyWith<$Res> {
  __$$DefaultReplyImplCopyWithImpl(
      _$DefaultReplyImpl _value, $Res Function(_$DefaultReplyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? memberId = null,
    Object? scheduleId = null,
    Object? selectedOption = null,
    Object? recurrenceRule = null,
  }) {
    return _then(_$DefaultReplyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      selectedOption: null == selectedOption
          ? _value.selectedOption
          : selectedOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions,
      recurrenceRule: null == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$DefaultReplyImpl with DiagnosticableTreeMixin implements _DefaultReply {
  const _$DefaultReplyImpl(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.memberId,
      required this.scheduleId,
      required this.selectedOption,
      required this.recurrenceRule});

  factory _$DefaultReplyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefaultReplyImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final int memberId;
  @override
  final int scheduleId;
  @override
  final ReplyOptions selectedOption;
  @override
  final RecurrenceRule recurrenceRule;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DefaultReply(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, memberId: $memberId, scheduleId: $scheduleId, selectedOption: $selectedOption, recurrenceRule: $recurrenceRule)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DefaultReply'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('memberId', memberId))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('selectedOption', selectedOption))
      ..add(DiagnosticsProperty('recurrenceRule', recurrenceRule));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefaultReplyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.selectedOption, selectedOption) ||
                other.selectedOption == selectedOption) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt,
      memberId, scheduleId, selectedOption, recurrenceRule);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DefaultReplyImplCopyWith<_$DefaultReplyImpl> get copyWith =>
      __$$DefaultReplyImplCopyWithImpl<_$DefaultReplyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefaultReplyImplToJson(
      this,
    );
  }
}

abstract class _DefaultReply implements DefaultReply {
  const factory _DefaultReply(
      {required final String id,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      required final int memberId,
      required final int scheduleId,
      required final ReplyOptions selectedOption,
      required final RecurrenceRule recurrenceRule}) = _$DefaultReplyImpl;

  factory _DefaultReply.fromJson(Map<String, dynamic> json) =
      _$DefaultReplyImpl.fromJson;

  @override
  String get id;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  int get memberId;
  @override
  int get scheduleId;
  @override
  ReplyOptions get selectedOption;
  @override
  RecurrenceRule get recurrenceRule;
  @override
  @JsonKey(ignore: true)
  _$$DefaultReplyImplCopyWith<_$DefaultReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
