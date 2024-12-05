// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduleInstanceSummary {
  int get scheduleId => throw _privateConstructorUsedError;
  int get groupId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get instanceDate => throw _privateConstructorUsedError;
  Map<int, ReplyOptions> get memberReplies =>
      throw _privateConstructorUsedError;
  Map<int, ReplyOptions> get memberDefaultReplyOptions =>
      throw _privateConstructorUsedError;
  Map<int, DefaultReply> get memberDefaultReplies =>
      throw _privateConstructorUsedError;
  int get yesCount => throw _privateConstructorUsedError;
  ReplyOptions? get myReply => throw _privateConstructorUsedError;
  ReplyOptions? get myDefaultReplyOption => throw _privateConstructorUsedError;
  DefaultReply? get myDefaultReply => throw _privateConstructorUsedError;
  int? get targetMemberId => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleInstanceSummaryCopyWith<ScheduleInstanceSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleInstanceSummaryCopyWith<$Res> {
  factory $ScheduleInstanceSummaryCopyWith(ScheduleInstanceSummary value,
          $Res Function(ScheduleInstanceSummary) then) =
      _$ScheduleInstanceSummaryCopyWithImpl<$Res, ScheduleInstanceSummary>;
  @useResult
  $Res call(
      {int scheduleId,
      int groupId,
      String displayName,
      DateTime instanceDate,
      Map<int, ReplyOptions> memberReplies,
      Map<int, ReplyOptions> memberDefaultReplyOptions,
      Map<int, DefaultReply> memberDefaultReplies,
      int yesCount,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReplyOption,
      DefaultReply? myDefaultReply,
      int? targetMemberId});

  $DefaultReplyCopyWith<$Res>? get myDefaultReply;
}

/// @nodoc
class _$ScheduleInstanceSummaryCopyWithImpl<$Res,
        $Val extends ScheduleInstanceSummary>
    implements $ScheduleInstanceSummaryCopyWith<$Res> {
  _$ScheduleInstanceSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? memberReplies = null,
    Object? memberDefaultReplyOptions = null,
    Object? memberDefaultReplies = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? myDefaultReplyOption = freezed,
    Object? myDefaultReply = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberReplies: null == memberReplies
          ? _value.memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplyOptions: null == memberDefaultReplyOptions
          ? _value.memberDefaultReplyOptions
          : memberDefaultReplyOptions // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value.memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, DefaultReply>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReplyOption: freezed == myDefaultReplyOption
          ? _value.myDefaultReplyOption
          : myDefaultReplyOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as DefaultReply?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultReplyCopyWith<$Res>? get myDefaultReply {
    if (_value.myDefaultReply == null) {
      return null;
    }

    return $DefaultReplyCopyWith<$Res>(_value.myDefaultReply!, (value) {
      return _then(_value.copyWith(myDefaultReply: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleInstanceSummaryImplCopyWith<$Res>
    implements $ScheduleInstanceSummaryCopyWith<$Res> {
  factory _$$ScheduleInstanceSummaryImplCopyWith(
          _$ScheduleInstanceSummaryImpl value,
          $Res Function(_$ScheduleInstanceSummaryImpl) then) =
      __$$ScheduleInstanceSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int scheduleId,
      int groupId,
      String displayName,
      DateTime instanceDate,
      Map<int, ReplyOptions> memberReplies,
      Map<int, ReplyOptions> memberDefaultReplyOptions,
      Map<int, DefaultReply> memberDefaultReplies,
      int yesCount,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReplyOption,
      DefaultReply? myDefaultReply,
      int? targetMemberId});

  @override
  $DefaultReplyCopyWith<$Res>? get myDefaultReply;
}

/// @nodoc
class __$$ScheduleInstanceSummaryImplCopyWithImpl<$Res>
    extends _$ScheduleInstanceSummaryCopyWithImpl<$Res,
        _$ScheduleInstanceSummaryImpl>
    implements _$$ScheduleInstanceSummaryImplCopyWith<$Res> {
  __$$ScheduleInstanceSummaryImplCopyWithImpl(
      _$ScheduleInstanceSummaryImpl _value,
      $Res Function(_$ScheduleInstanceSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? memberReplies = null,
    Object? memberDefaultReplyOptions = null,
    Object? memberDefaultReplies = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? myDefaultReplyOption = freezed,
    Object? myDefaultReply = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_$ScheduleInstanceSummaryImpl(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberReplies: null == memberReplies
          ? _value._memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplyOptions: null == memberDefaultReplyOptions
          ? _value._memberDefaultReplyOptions
          : memberDefaultReplyOptions // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value._memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, DefaultReply>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReplyOption: freezed == myDefaultReplyOption
          ? _value.myDefaultReplyOption
          : myDefaultReplyOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as DefaultReply?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ScheduleInstanceSummaryImpl
    with DiagnosticableTreeMixin
    implements _ScheduleInstanceSummary {
  const _$ScheduleInstanceSummaryImpl(
      {required this.scheduleId,
      required this.groupId,
      required this.displayName,
      required this.instanceDate,
      required final Map<int, ReplyOptions> memberReplies,
      required final Map<int, ReplyOptions> memberDefaultReplyOptions,
      required final Map<int, DefaultReply> memberDefaultReplies,
      required this.yesCount,
      this.myReply,
      this.myDefaultReplyOption,
      this.myDefaultReply,
      this.targetMemberId})
      : _memberReplies = memberReplies,
        _memberDefaultReplyOptions = memberDefaultReplyOptions,
        _memberDefaultReplies = memberDefaultReplies;

  @override
  final int scheduleId;
  @override
  final int groupId;
  @override
  final String displayName;
  @override
  final DateTime instanceDate;
  final Map<int, ReplyOptions> _memberReplies;
  @override
  Map<int, ReplyOptions> get memberReplies {
    if (_memberReplies is EqualUnmodifiableMapView) return _memberReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberReplies);
  }

  final Map<int, ReplyOptions> _memberDefaultReplyOptions;
  @override
  Map<int, ReplyOptions> get memberDefaultReplyOptions {
    if (_memberDefaultReplyOptions is EqualUnmodifiableMapView)
      return _memberDefaultReplyOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultReplyOptions);
  }

  final Map<int, DefaultReply> _memberDefaultReplies;
  @override
  Map<int, DefaultReply> get memberDefaultReplies {
    if (_memberDefaultReplies is EqualUnmodifiableMapView)
      return _memberDefaultReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultReplies);
  }

  @override
  final int yesCount;
  @override
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReplyOption;
  @override
  final DefaultReply? myDefaultReply;
  @override
  final int? targetMemberId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceSummary(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, memberReplies: $memberReplies, memberDefaultReplyOptions: $memberDefaultReplyOptions, memberDefaultReplies: $memberDefaultReplies, yesCount: $yesCount, myReply: $myReply, myDefaultReplyOption: $myDefaultReplyOption, myDefaultReply: $myDefaultReply, targetMemberId: $targetMemberId)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceSummary'))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('groupId', groupId))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('instanceDate', instanceDate))
      ..add(DiagnosticsProperty('memberReplies', memberReplies))
      ..add(DiagnosticsProperty(
          'memberDefaultReplyOptions', memberDefaultReplyOptions))
      ..add(DiagnosticsProperty('memberDefaultReplies', memberDefaultReplies))
      ..add(DiagnosticsProperty('yesCount', yesCount))
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReplyOption', myDefaultReplyOption))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('targetMemberId', targetMemberId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleInstanceSummaryImpl &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            const DeepCollectionEquality()
                .equals(other._memberReplies, _memberReplies) &&
            const DeepCollectionEquality().equals(
                other._memberDefaultReplyOptions, _memberDefaultReplyOptions) &&
            const DeepCollectionEquality()
                .equals(other._memberDefaultReplies, _memberDefaultReplies) &&
            (identical(other.yesCount, yesCount) ||
                other.yesCount == yesCount) &&
            (identical(other.myReply, myReply) || other.myReply == myReply) &&
            (identical(other.myDefaultReplyOption, myDefaultReplyOption) ||
                other.myDefaultReplyOption == myDefaultReplyOption) &&
            (identical(other.myDefaultReply, myDefaultReply) ||
                other.myDefaultReply == myDefaultReply) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      scheduleId,
      groupId,
      displayName,
      instanceDate,
      const DeepCollectionEquality().hash(_memberReplies),
      const DeepCollectionEquality().hash(_memberDefaultReplyOptions),
      const DeepCollectionEquality().hash(_memberDefaultReplies),
      yesCount,
      myReply,
      myDefaultReplyOption,
      myDefaultReply,
      targetMemberId);

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleInstanceSummaryImplCopyWith<_$ScheduleInstanceSummaryImpl>
      get copyWith => __$$ScheduleInstanceSummaryImplCopyWithImpl<
          _$ScheduleInstanceSummaryImpl>(this, _$identity);
}

abstract class _ScheduleInstanceSummary implements ScheduleInstanceSummary {
  const factory _ScheduleInstanceSummary(
      {required final int scheduleId,
      required final int groupId,
      required final String displayName,
      required final DateTime instanceDate,
      required final Map<int, ReplyOptions> memberReplies,
      required final Map<int, ReplyOptions> memberDefaultReplyOptions,
      required final Map<int, DefaultReply> memberDefaultReplies,
      required final int yesCount,
      final ReplyOptions? myReply,
      final ReplyOptions? myDefaultReplyOption,
      final DefaultReply? myDefaultReply,
      final int? targetMemberId}) = _$ScheduleInstanceSummaryImpl;

  @override
  int get scheduleId;
  @override
  int get groupId;
  @override
  String get displayName;
  @override
  DateTime get instanceDate;
  @override
  Map<int, ReplyOptions> get memberReplies;
  @override
  Map<int, ReplyOptions> get memberDefaultReplyOptions;
  @override
  Map<int, DefaultReply> get memberDefaultReplies;
  @override
  int get yesCount;
  @override
  ReplyOptions? get myReply;
  @override
  ReplyOptions? get myDefaultReplyOption;
  @override
  DefaultReply? get myDefaultReply;
  @override
  int? get targetMemberId;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceSummaryImplCopyWith<_$ScheduleInstanceSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleInstanceDetails {
  int get scheduleId => throw _privateConstructorUsedError;
  int get groupId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get instanceDate => throw _privateConstructorUsedError;
  List<(Member, Profile?)> get members => throw _privateConstructorUsedError;
  Map<int, ReplyOptions> get memberReplies =>
      throw _privateConstructorUsedError;
  Map<int, ReplyOptions> get memberDefaultReplyOptions =>
      throw _privateConstructorUsedError;
  Map<int, DefaultReply> get memberDefaultReplies =>
      throw _privateConstructorUsedError;
  int get yesCount => throw _privateConstructorUsedError;
  ReplyOptions? get myReply => throw _privateConstructorUsedError;
  ReplyOptions? get myDefaultReplyOption => throw _privateConstructorUsedError;
  DefaultReply? get myDefaultReply => throw _privateConstructorUsedError;
  int? get targetMemberId => throw _privateConstructorUsedError;
  bool? get canEditOthers => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleInstanceDetailsCopyWith<ScheduleInstanceDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleInstanceDetailsCopyWith<$Res> {
  factory $ScheduleInstanceDetailsCopyWith(ScheduleInstanceDetails value,
          $Res Function(ScheduleInstanceDetails) then) =
      _$ScheduleInstanceDetailsCopyWithImpl<$Res, ScheduleInstanceDetails>;
  @useResult
  $Res call(
      {int scheduleId,
      int groupId,
      String displayName,
      DateTime instanceDate,
      List<(Member, Profile?)> members,
      Map<int, ReplyOptions> memberReplies,
      Map<int, ReplyOptions> memberDefaultReplyOptions,
      Map<int, DefaultReply> memberDefaultReplies,
      int yesCount,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReplyOption,
      DefaultReply? myDefaultReply,
      int? targetMemberId,
      bool? canEditOthers});

  $DefaultReplyCopyWith<$Res>? get myDefaultReply;
}

/// @nodoc
class _$ScheduleInstanceDetailsCopyWithImpl<$Res,
        $Val extends ScheduleInstanceDetails>
    implements $ScheduleInstanceDetailsCopyWith<$Res> {
  _$ScheduleInstanceDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? members = null,
    Object? memberReplies = null,
    Object? memberDefaultReplyOptions = null,
    Object? memberDefaultReplies = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? myDefaultReplyOption = freezed,
    Object? myDefaultReply = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<(Member, Profile?)>,
      memberReplies: null == memberReplies
          ? _value.memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplyOptions: null == memberDefaultReplyOptions
          ? _value.memberDefaultReplyOptions
          : memberDefaultReplyOptions // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value.memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, DefaultReply>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReplyOption: freezed == myDefaultReplyOption
          ? _value.myDefaultReplyOption
          : myDefaultReplyOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as DefaultReply?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
      canEditOthers: freezed == canEditOthers
          ? _value.canEditOthers
          : canEditOthers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultReplyCopyWith<$Res>? get myDefaultReply {
    if (_value.myDefaultReply == null) {
      return null;
    }

    return $DefaultReplyCopyWith<$Res>(_value.myDefaultReply!, (value) {
      return _then(_value.copyWith(myDefaultReply: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleInstanceDetailsImplCopyWith<$Res>
    implements $ScheduleInstanceDetailsCopyWith<$Res> {
  factory _$$ScheduleInstanceDetailsImplCopyWith(
          _$ScheduleInstanceDetailsImpl value,
          $Res Function(_$ScheduleInstanceDetailsImpl) then) =
      __$$ScheduleInstanceDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int scheduleId,
      int groupId,
      String displayName,
      DateTime instanceDate,
      List<(Member, Profile?)> members,
      Map<int, ReplyOptions> memberReplies,
      Map<int, ReplyOptions> memberDefaultReplyOptions,
      Map<int, DefaultReply> memberDefaultReplies,
      int yesCount,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReplyOption,
      DefaultReply? myDefaultReply,
      int? targetMemberId,
      bool? canEditOthers});

  @override
  $DefaultReplyCopyWith<$Res>? get myDefaultReply;
}

/// @nodoc
class __$$ScheduleInstanceDetailsImplCopyWithImpl<$Res>
    extends _$ScheduleInstanceDetailsCopyWithImpl<$Res,
        _$ScheduleInstanceDetailsImpl>
    implements _$$ScheduleInstanceDetailsImplCopyWith<$Res> {
  __$$ScheduleInstanceDetailsImplCopyWithImpl(
      _$ScheduleInstanceDetailsImpl _value,
      $Res Function(_$ScheduleInstanceDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? members = null,
    Object? memberReplies = null,
    Object? memberDefaultReplyOptions = null,
    Object? memberDefaultReplies = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? myDefaultReplyOption = freezed,
    Object? myDefaultReply = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_$ScheduleInstanceDetailsImpl(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<(Member, Profile?)>,
      memberReplies: null == memberReplies
          ? _value._memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplyOptions: null == memberDefaultReplyOptions
          ? _value._memberDefaultReplyOptions
          : memberDefaultReplyOptions // ignore: cast_nullable_to_non_nullable
              as Map<int, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value._memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<int, DefaultReply>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReplyOption: freezed == myDefaultReplyOption
          ? _value.myDefaultReplyOption
          : myDefaultReplyOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as DefaultReply?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as int?,
      canEditOthers: freezed == canEditOthers
          ? _value.canEditOthers
          : canEditOthers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$ScheduleInstanceDetailsImpl
    with DiagnosticableTreeMixin
    implements _ScheduleInstanceDetails {
  const _$ScheduleInstanceDetailsImpl(
      {required this.scheduleId,
      required this.groupId,
      required this.displayName,
      required this.instanceDate,
      required final List<(Member, Profile?)> members,
      required final Map<int, ReplyOptions> memberReplies,
      required final Map<int, ReplyOptions> memberDefaultReplyOptions,
      required final Map<int, DefaultReply> memberDefaultReplies,
      required this.yesCount,
      this.myReply,
      this.myDefaultReplyOption,
      this.myDefaultReply,
      this.targetMemberId,
      this.canEditOthers})
      : _members = members,
        _memberReplies = memberReplies,
        _memberDefaultReplyOptions = memberDefaultReplyOptions,
        _memberDefaultReplies = memberDefaultReplies;

  @override
  final int scheduleId;
  @override
  final int groupId;
  @override
  final String displayName;
  @override
  final DateTime instanceDate;
  final List<(Member, Profile?)> _members;
  @override
  List<(Member, Profile?)> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final Map<int, ReplyOptions> _memberReplies;
  @override
  Map<int, ReplyOptions> get memberReplies {
    if (_memberReplies is EqualUnmodifiableMapView) return _memberReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberReplies);
  }

  final Map<int, ReplyOptions> _memberDefaultReplyOptions;
  @override
  Map<int, ReplyOptions> get memberDefaultReplyOptions {
    if (_memberDefaultReplyOptions is EqualUnmodifiableMapView)
      return _memberDefaultReplyOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultReplyOptions);
  }

  final Map<int, DefaultReply> _memberDefaultReplies;
  @override
  Map<int, DefaultReply> get memberDefaultReplies {
    if (_memberDefaultReplies is EqualUnmodifiableMapView)
      return _memberDefaultReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultReplies);
  }

  @override
  final int yesCount;
  @override
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReplyOption;
  @override
  final DefaultReply? myDefaultReply;
  @override
  final int? targetMemberId;
  @override
  final bool? canEditOthers;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceDetails(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, members: $members, memberReplies: $memberReplies, memberDefaultReplyOptions: $memberDefaultReplyOptions, memberDefaultReplies: $memberDefaultReplies, yesCount: $yesCount, myReply: $myReply, myDefaultReplyOption: $myDefaultReplyOption, myDefaultReply: $myDefaultReply, targetMemberId: $targetMemberId, canEditOthers: $canEditOthers)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceDetails'))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('groupId', groupId))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('instanceDate', instanceDate))
      ..add(DiagnosticsProperty('members', members))
      ..add(DiagnosticsProperty('memberReplies', memberReplies))
      ..add(DiagnosticsProperty(
          'memberDefaultReplyOptions', memberDefaultReplyOptions))
      ..add(DiagnosticsProperty('memberDefaultReplies', memberDefaultReplies))
      ..add(DiagnosticsProperty('yesCount', yesCount))
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReplyOption', myDefaultReplyOption))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('targetMemberId', targetMemberId))
      ..add(DiagnosticsProperty('canEditOthers', canEditOthers));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleInstanceDetailsImpl &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._memberReplies, _memberReplies) &&
            const DeepCollectionEquality().equals(
                other._memberDefaultReplyOptions, _memberDefaultReplyOptions) &&
            const DeepCollectionEquality()
                .equals(other._memberDefaultReplies, _memberDefaultReplies) &&
            (identical(other.yesCount, yesCount) ||
                other.yesCount == yesCount) &&
            (identical(other.myReply, myReply) || other.myReply == myReply) &&
            (identical(other.myDefaultReplyOption, myDefaultReplyOption) ||
                other.myDefaultReplyOption == myDefaultReplyOption) &&
            (identical(other.myDefaultReply, myDefaultReply) ||
                other.myDefaultReply == myDefaultReply) &&
            (identical(other.targetMemberId, targetMemberId) ||
                other.targetMemberId == targetMemberId) &&
            (identical(other.canEditOthers, canEditOthers) ||
                other.canEditOthers == canEditOthers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      scheduleId,
      groupId,
      displayName,
      instanceDate,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_memberReplies),
      const DeepCollectionEquality().hash(_memberDefaultReplyOptions),
      const DeepCollectionEquality().hash(_memberDefaultReplies),
      yesCount,
      myReply,
      myDefaultReplyOption,
      myDefaultReply,
      targetMemberId,
      canEditOthers);

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleInstanceDetailsImplCopyWith<_$ScheduleInstanceDetailsImpl>
      get copyWith => __$$ScheduleInstanceDetailsImplCopyWithImpl<
          _$ScheduleInstanceDetailsImpl>(this, _$identity);
}

abstract class _ScheduleInstanceDetails implements ScheduleInstanceDetails {
  const factory _ScheduleInstanceDetails(
      {required final int scheduleId,
      required final int groupId,
      required final String displayName,
      required final DateTime instanceDate,
      required final List<(Member, Profile?)> members,
      required final Map<int, ReplyOptions> memberReplies,
      required final Map<int, ReplyOptions> memberDefaultReplyOptions,
      required final Map<int, DefaultReply> memberDefaultReplies,
      required final int yesCount,
      final ReplyOptions? myReply,
      final ReplyOptions? myDefaultReplyOption,
      final DefaultReply? myDefaultReply,
      final int? targetMemberId,
      final bool? canEditOthers}) = _$ScheduleInstanceDetailsImpl;

  @override
  int get scheduleId;
  @override
  int get groupId;
  @override
  String get displayName;
  @override
  DateTime get instanceDate;
  @override
  List<(Member, Profile?)> get members;
  @override
  Map<int, ReplyOptions> get memberReplies;
  @override
  Map<int, ReplyOptions> get memberDefaultReplyOptions;
  @override
  Map<int, DefaultReply> get memberDefaultReplies;
  @override
  int get yesCount;
  @override
  ReplyOptions? get myReply;
  @override
  ReplyOptions? get myDefaultReplyOption;
  @override
  DefaultReply? get myDefaultReply;
  @override
  int? get targetMemberId;
  @override
  bool? get canEditOthers;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceDetailsImplCopyWith<_$ScheduleInstanceDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
