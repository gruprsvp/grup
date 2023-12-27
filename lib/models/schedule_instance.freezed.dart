// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScheduleInstance {
  int get scheduleId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  int get yesCount => throw _privateConstructorUsedError;
  ReplyOptions? get myReply => throw _privateConstructorUsedError;
  int? get targetMemberId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduleInstanceCopyWith<ScheduleInstance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleInstanceCopyWith<$Res> {
  factory $ScheduleInstanceCopyWith(
          ScheduleInstance value, $Res Function(ScheduleInstance) then) =
      _$ScheduleInstanceCopyWithImpl<$Res, ScheduleInstance>;
  @useResult
  $Res call(
      {int scheduleId,
      String displayName,
      DateTime eventDate,
      int yesCount,
      ReplyOptions? myReply,
      int? targetMemberId});
}

/// @nodoc
class _$ScheduleInstanceCopyWithImpl<$Res, $Val extends ScheduleInstance>
    implements $ScheduleInstanceCopyWith<$Res> {
  _$ScheduleInstanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? displayName = null,
    Object? eventDate = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleInstanceImplCopyWith<$Res>
    implements $ScheduleInstanceCopyWith<$Res> {
  factory _$$ScheduleInstanceImplCopyWith(_$ScheduleInstanceImpl value,
          $Res Function(_$ScheduleInstanceImpl) then) =
      __$$ScheduleInstanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int scheduleId,
      String displayName,
      DateTime eventDate,
      int yesCount,
      ReplyOptions? myReply,
      int? targetMemberId});
}

/// @nodoc
class __$$ScheduleInstanceImplCopyWithImpl<$Res>
    extends _$ScheduleInstanceCopyWithImpl<$Res, _$ScheduleInstanceImpl>
    implements _$$ScheduleInstanceImplCopyWith<$Res> {
  __$$ScheduleInstanceImplCopyWithImpl(_$ScheduleInstanceImpl _value,
      $Res Function(_$ScheduleInstanceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? displayName = null,
    Object? eventDate = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_$ScheduleInstanceImpl(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ScheduleInstanceImpl
    with DiagnosticableTreeMixin
    implements _ScheduleInstance {
  const _$ScheduleInstanceImpl(
      {required this.scheduleId,
      required this.displayName,
      required this.eventDate,
      required this.yesCount,
      this.myReply,
      this.targetMemberId});

  @override
  final int scheduleId;
  @override
  final String displayName;
  @override
  final DateTime eventDate;
  @override
  final int yesCount;
  @override
  final ReplyOptions? myReply;
  @override
  final int? targetMemberId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstance(scheduleId: $scheduleId, displayName: $displayName, eventDate: $eventDate, yesCount: $yesCount, myReply: $myReply, targetMemberId: $targetMemberId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstance'))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('eventDate', eventDate))
      ..add(DiagnosticsProperty('yesCount', yesCount))
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('targetMemberId', targetMemberId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleInstanceImpl &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.yesCount, yesCount) ||
                other.yesCount == yesCount) &&
            (identical(other.myReply, myReply) || other.myReply == myReply) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, scheduleId, displayName,
      eventDate, yesCount, myReply, targetMemberId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleInstanceImplCopyWith<_$ScheduleInstanceImpl> get copyWith =>
      __$$ScheduleInstanceImplCopyWithImpl<_$ScheduleInstanceImpl>(
          this, _$identity);
}

abstract class _ScheduleInstance implements ScheduleInstance {
  const factory _ScheduleInstance(
      {required final int scheduleId,
      required final String displayName,
      required final DateTime eventDate,
      required final int yesCount,
      final ReplyOptions? myReply,
      final int? targetMemberId}) = _$ScheduleInstanceImpl;

  @override
  int get scheduleId;
  @override
  String get displayName;
  @override
  DateTime get eventDate;
  @override
  int get yesCount;
  @override
  ReplyOptions? get myReply;
  @override
  int? get targetMemberId;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleInstanceImplCopyWith<_$ScheduleInstanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
