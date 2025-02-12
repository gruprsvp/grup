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
  String get scheduleId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get instanceDate => throw _privateConstructorUsedError;
  Map<String, ReplyOptions> get memberReplies =>
      throw _privateConstructorUsedError;
  Map<String, ReplyOptions> get memberDefaultReplies =>
      throw _privateConstructorUsedError;
  Map<String, DefaultRule> get memberDefaultRules =>
      throw _privateConstructorUsedError;
  int get yesCount => throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  ReplyOptions? get myReply => throw _privateConstructorUsedError;
  ReplyOptions? get myDefaultReply => throw _privateConstructorUsedError;
  DefaultRule? get myDefaultRule => throw _privateConstructorUsedError;
  String? get targetMemberId => throw _privateConstructorUsedError;

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
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      Map<String, ReplyOptions> memberReplies,
      Map<String, ReplyOptions> memberDefaultReplies,
      Map<String, DefaultRule> memberDefaultRules,
      int yesCount,
      String timezone,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId});

  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
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
    Object? memberDefaultReplies = null,
    Object? memberDefaultRules = null,
    Object? yesCount = null,
    Object? timezone = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as Map<String, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value.memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultRules: null == memberDefaultRules
          ? _value.memberDefaultRules
          : memberDefaultRules // ignore: cast_nullable_to_non_nullable
              as Map<String, DefaultRule>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _value.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_value.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_value.myDefaultRule!, (value) {
      return _then(_value.copyWith(myDefaultRule: value) as $Val);
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
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      Map<String, ReplyOptions> memberReplies,
      Map<String, ReplyOptions> memberDefaultReplies,
      Map<String, DefaultRule> memberDefaultRules,
      int yesCount,
      String timezone,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId});

  @override
  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
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
    Object? memberDefaultReplies = null,
    Object? memberDefaultRules = null,
    Object? yesCount = null,
    Object? timezone = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_$ScheduleInstanceSummaryImpl(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
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
              as Map<String, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _value._memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultRules: null == memberDefaultRules
          ? _value._memberDefaultRules
          : memberDefaultRules // ignore: cast_nullable_to_non_nullable
              as Map<String, DefaultRule>,
      yesCount: null == yesCount
          ? _value.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _value.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      required final Map<String, ReplyOptions> memberReplies,
      required final Map<String, ReplyOptions> memberDefaultReplies,
      required final Map<String, DefaultRule> memberDefaultRules,
      required this.yesCount,
      required this.timezone,
      this.myReply,
      this.myDefaultReply,
      this.myDefaultRule,
      this.targetMemberId})
      : _memberReplies = memberReplies,
        _memberDefaultReplies = memberDefaultReplies,
        _memberDefaultRules = memberDefaultRules;

  @override
  final String scheduleId;
  @override
  final String groupId;
  @override
  final String displayName;
  @override
  final DateTime instanceDate;
  final Map<String, ReplyOptions> _memberReplies;
  @override
  Map<String, ReplyOptions> get memberReplies {
    if (_memberReplies is EqualUnmodifiableMapView) return _memberReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberReplies);
  }

  final Map<String, ReplyOptions> _memberDefaultReplies;
  @override
  Map<String, ReplyOptions> get memberDefaultReplies {
    if (_memberDefaultReplies is EqualUnmodifiableMapView)
      return _memberDefaultReplies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultReplies);
  }

  final Map<String, DefaultRule> _memberDefaultRules;
  @override
  Map<String, DefaultRule> get memberDefaultRules {
    if (_memberDefaultRules is EqualUnmodifiableMapView)
      return _memberDefaultRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberDefaultRules);
  }

  @override
  final int yesCount;
  @override
  final String timezone;
  @override
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReply;
  @override
  final DefaultRule? myDefaultRule;
  @override
  final String? targetMemberId;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceSummary(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, memberReplies: $memberReplies, memberDefaultReplies: $memberDefaultReplies, memberDefaultRules: $memberDefaultRules, yesCount: $yesCount, timezone: $timezone, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId)';
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
      ..add(DiagnosticsProperty('memberDefaultReplies', memberDefaultReplies))
      ..add(DiagnosticsProperty('memberDefaultRules', memberDefaultRules))
      ..add(DiagnosticsProperty('yesCount', yesCount))
      ..add(DiagnosticsProperty('timezone', timezone))
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('myDefaultRule', myDefaultRule))
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
            const DeepCollectionEquality()
                .equals(other._memberDefaultReplies, _memberDefaultReplies) &&
            const DeepCollectionEquality()
                .equals(other._memberDefaultRules, _memberDefaultRules) &&
            (identical(other.yesCount, yesCount) ||
                other.yesCount == yesCount) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.myReply, myReply) || other.myReply == myReply) &&
            (identical(other.myDefaultReply, myDefaultReply) ||
                other.myDefaultReply == myDefaultReply) &&
            (identical(other.myDefaultRule, myDefaultRule) ||
                other.myDefaultRule == myDefaultRule) &&
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
      const DeepCollectionEquality().hash(_memberDefaultReplies),
      const DeepCollectionEquality().hash(_memberDefaultRules),
      yesCount,
      timezone,
      myReply,
      myDefaultReply,
      myDefaultRule,
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
      {required final String scheduleId,
      required final String groupId,
      required final String displayName,
      required final DateTime instanceDate,
      required final Map<String, ReplyOptions> memberReplies,
      required final Map<String, ReplyOptions> memberDefaultReplies,
      required final Map<String, DefaultRule> memberDefaultRules,
      required final int yesCount,
      required final String timezone,
      final ReplyOptions? myReply,
      final ReplyOptions? myDefaultReply,
      final DefaultRule? myDefaultRule,
      final String? targetMemberId}) = _$ScheduleInstanceSummaryImpl;

  @override
  String get scheduleId;
  @override
  String get groupId;
  @override
  String get displayName;
  @override
  DateTime get instanceDate;
  @override
  Map<String, ReplyOptions> get memberReplies;
  @override
  Map<String, ReplyOptions> get memberDefaultReplies;
  @override
  Map<String, DefaultRule> get memberDefaultRules;
  @override
  int get yesCount;
  @override
  String get timezone;
  @override
  ReplyOptions? get myReply;
  @override
  ReplyOptions? get myDefaultReply;
  @override
  DefaultRule? get myDefaultRule;
  @override
  String? get targetMemberId;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceSummaryImplCopyWith<_$ScheduleInstanceSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleInstanceDetails {
  String get scheduleId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get instanceDate => throw _privateConstructorUsedError;
  List<ScheduleInstanceRepliesGroup> get repliesGroups =>
      throw _privateConstructorUsedError;
  String get timezone => throw _privateConstructorUsedError;
  ReplyOptions? get myReply => throw _privateConstructorUsedError;
  ReplyOptions? get myDefaultReply => throw _privateConstructorUsedError;
  DefaultRule? get myDefaultRule => throw _privateConstructorUsedError;
  String? get targetMemberId => throw _privateConstructorUsedError;
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
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      List<ScheduleInstanceRepliesGroup> repliesGroups,
      String timezone,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId,
      bool? canEditOthers});

  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
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
    Object? repliesGroups = null,
    Object? timezone = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_value.copyWith(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repliesGroups: null == repliesGroups
          ? _value.repliesGroups
          : repliesGroups // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceRepliesGroup>,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _value.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
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
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_value.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_value.myDefaultRule!, (value) {
      return _then(_value.copyWith(myDefaultRule: value) as $Val);
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
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      List<ScheduleInstanceRepliesGroup> repliesGroups,
      String timezone,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId,
      bool? canEditOthers});

  @override
  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
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
    Object? repliesGroups = null,
    Object? timezone = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_$ScheduleInstanceDetailsImpl(
      scheduleId: null == scheduleId
          ? _value.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _value.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repliesGroups: null == repliesGroups
          ? _value._repliesGroups
          : repliesGroups // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceRepliesGroup>,
      timezone: null == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      myReply: freezed == myReply
          ? _value.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _value.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _value.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _value.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      required final List<ScheduleInstanceRepliesGroup> repliesGroups,
      required this.timezone,
      this.myReply,
      this.myDefaultReply,
      this.myDefaultRule,
      this.targetMemberId,
      this.canEditOthers})
      : _repliesGroups = repliesGroups;

  @override
  final String scheduleId;
  @override
  final String groupId;
  @override
  final String displayName;
  @override
  final DateTime instanceDate;
  final List<ScheduleInstanceRepliesGroup> _repliesGroups;
  @override
  List<ScheduleInstanceRepliesGroup> get repliesGroups {
    if (_repliesGroups is EqualUnmodifiableListView) return _repliesGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_repliesGroups);
  }

  @override
  final String timezone;
  @override
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReply;
  @override
  final DefaultRule? myDefaultRule;
  @override
  final String? targetMemberId;
  @override
  final bool? canEditOthers;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceDetails(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, repliesGroups: $repliesGroups, timezone: $timezone, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId, canEditOthers: $canEditOthers)';
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
      ..add(DiagnosticsProperty('repliesGroups', repliesGroups))
      ..add(DiagnosticsProperty('timezone', timezone))
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('myDefaultRule', myDefaultRule))
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
            const DeepCollectionEquality()
                .equals(other._repliesGroups, _repliesGroups) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.myReply, myReply) || other.myReply == myReply) &&
            (identical(other.myDefaultReply, myDefaultReply) ||
                other.myDefaultReply == myDefaultReply) &&
            (identical(other.myDefaultRule, myDefaultRule) ||
                other.myDefaultRule == myDefaultRule) &&
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
      const DeepCollectionEquality().hash(_repliesGroups),
      timezone,
      myReply,
      myDefaultReply,
      myDefaultRule,
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
      {required final String scheduleId,
      required final String groupId,
      required final String displayName,
      required final DateTime instanceDate,
      required final List<ScheduleInstanceRepliesGroup> repliesGroups,
      required final String timezone,
      final ReplyOptions? myReply,
      final ReplyOptions? myDefaultReply,
      final DefaultRule? myDefaultRule,
      final String? targetMemberId,
      final bool? canEditOthers}) = _$ScheduleInstanceDetailsImpl;

  @override
  String get scheduleId;
  @override
  String get groupId;
  @override
  String get displayName;
  @override
  DateTime get instanceDate;
  @override
  List<ScheduleInstanceRepliesGroup> get repliesGroups;
  @override
  String get timezone;
  @override
  ReplyOptions? get myReply;
  @override
  ReplyOptions? get myDefaultReply;
  @override
  DefaultRule? get myDefaultRule;
  @override
  String? get targetMemberId;
  @override
  bool? get canEditOthers;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceDetailsImplCopyWith<_$ScheduleInstanceDetailsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleInstanceRepliesGroup {
  ReplyOptions? get reply => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  List<ScheduleInstanceMember> get members =>
      throw _privateConstructorUsedError;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleInstanceRepliesGroupCopyWith<ScheduleInstanceRepliesGroup>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  factory $ScheduleInstanceRepliesGroupCopyWith(
          ScheduleInstanceRepliesGroup value,
          $Res Function(ScheduleInstanceRepliesGroup) then) =
      _$ScheduleInstanceRepliesGroupCopyWithImpl<$Res,
          ScheduleInstanceRepliesGroup>;
  @useResult
  $Res call(
      {ReplyOptions? reply, int count, List<ScheduleInstanceMember> members});
}

/// @nodoc
class _$ScheduleInstanceRepliesGroupCopyWithImpl<$Res,
        $Val extends ScheduleInstanceRepliesGroup>
    implements $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  _$ScheduleInstanceRepliesGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reply = freezed,
    Object? count = null,
    Object? members = null,
  }) {
    return _then(_value.copyWith(
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceMember>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleInstanceRepliesGroupImplCopyWith<$Res>
    implements $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  factory _$$ScheduleInstanceRepliesGroupImplCopyWith(
          _$ScheduleInstanceRepliesGroupImpl value,
          $Res Function(_$ScheduleInstanceRepliesGroupImpl) then) =
      __$$ScheduleInstanceRepliesGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ReplyOptions? reply, int count, List<ScheduleInstanceMember> members});
}

/// @nodoc
class __$$ScheduleInstanceRepliesGroupImplCopyWithImpl<$Res>
    extends _$ScheduleInstanceRepliesGroupCopyWithImpl<$Res,
        _$ScheduleInstanceRepliesGroupImpl>
    implements _$$ScheduleInstanceRepliesGroupImplCopyWith<$Res> {
  __$$ScheduleInstanceRepliesGroupImplCopyWithImpl(
      _$ScheduleInstanceRepliesGroupImpl _value,
      $Res Function(_$ScheduleInstanceRepliesGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reply = freezed,
    Object? count = null,
    Object? members = null,
  }) {
    return _then(_$ScheduleInstanceRepliesGroupImpl(
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceMember>,
    ));
  }
}

/// @nodoc

class _$ScheduleInstanceRepliesGroupImpl
    with DiagnosticableTreeMixin
    implements _ScheduleInstanceRepliesGroup {
  const _$ScheduleInstanceRepliesGroupImpl(
      {required this.reply,
      required this.count,
      required final List<ScheduleInstanceMember> members})
      : _members = members;

  @override
  final ReplyOptions? reply;
  @override
  final int count;
  final List<ScheduleInstanceMember> _members;
  @override
  List<ScheduleInstanceMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceRepliesGroup(reply: $reply, count: $count, members: $members)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceRepliesGroup'))
      ..add(DiagnosticsProperty('reply', reply))
      ..add(DiagnosticsProperty('count', count))
      ..add(DiagnosticsProperty('members', members));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleInstanceRepliesGroupImpl &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, reply, count, const DeepCollectionEquality().hash(_members));

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleInstanceRepliesGroupImplCopyWith<
          _$ScheduleInstanceRepliesGroupImpl>
      get copyWith => __$$ScheduleInstanceRepliesGroupImplCopyWithImpl<
          _$ScheduleInstanceRepliesGroupImpl>(this, _$identity);
}

abstract class _ScheduleInstanceRepliesGroup
    implements ScheduleInstanceRepliesGroup {
  const factory _ScheduleInstanceRepliesGroup(
          {required final ReplyOptions? reply,
          required final int count,
          required final List<ScheduleInstanceMember> members}) =
      _$ScheduleInstanceRepliesGroupImpl;

  @override
  ReplyOptions? get reply;
  @override
  int get count;
  @override
  List<ScheduleInstanceMember> get members;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceRepliesGroupImplCopyWith<
          _$ScheduleInstanceRepliesGroupImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleInstanceMember {
  Member get member => throw _privateConstructorUsedError;
  ReplyOptions? get reply => throw _privateConstructorUsedError;
  ReplyOptions? get defaultReply => throw _privateConstructorUsedError;
  DefaultRule? get defaultRule => throw _privateConstructorUsedError;
  Profile? get profile => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleInstanceMemberCopyWith<ScheduleInstanceMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleInstanceMemberCopyWith<$Res> {
  factory $ScheduleInstanceMemberCopyWith(ScheduleInstanceMember value,
          $Res Function(ScheduleInstanceMember) then) =
      _$ScheduleInstanceMemberCopyWithImpl<$Res, ScheduleInstanceMember>;
  @useResult
  $Res call(
      {Member member,
      ReplyOptions? reply,
      ReplyOptions? defaultReply,
      DefaultRule? defaultRule,
      Profile? profile});

  $MemberCopyWith<$Res> get member;
  $DefaultRuleCopyWith<$Res>? get defaultRule;
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class _$ScheduleInstanceMemberCopyWithImpl<$Res,
        $Val extends ScheduleInstanceMember>
    implements $ScheduleInstanceMemberCopyWith<$Res> {
  _$ScheduleInstanceMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member = null,
    Object? reply = freezed,
    Object? defaultReply = freezed,
    Object? defaultRule = freezed,
    Object? profile = freezed,
  }) {
    return _then(_value.copyWith(
      member: null == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultReply: freezed == defaultReply
          ? _value.defaultReply
          : defaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultRule: freezed == defaultRule
          ? _value.defaultRule
          : defaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ) as $Val);
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get member {
    return $MemberCopyWith<$Res>(_value.member, (value) {
      return _then(_value.copyWith(member: value) as $Val);
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get defaultRule {
    if (_value.defaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_value.defaultRule!, (value) {
      return _then(_value.copyWith(defaultRule: value) as $Val);
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleInstanceMemberReplyImplCopyWith<$Res>
    implements $ScheduleInstanceMemberCopyWith<$Res> {
  factory _$$ScheduleInstanceMemberReplyImplCopyWith(
          _$ScheduleInstanceMemberReplyImpl value,
          $Res Function(_$ScheduleInstanceMemberReplyImpl) then) =
      __$$ScheduleInstanceMemberReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Member member,
      ReplyOptions? reply,
      ReplyOptions? defaultReply,
      DefaultRule? defaultRule,
      Profile? profile});

  @override
  $MemberCopyWith<$Res> get member;
  @override
  $DefaultRuleCopyWith<$Res>? get defaultRule;
  @override
  $ProfileCopyWith<$Res>? get profile;
}

/// @nodoc
class __$$ScheduleInstanceMemberReplyImplCopyWithImpl<$Res>
    extends _$ScheduleInstanceMemberCopyWithImpl<$Res,
        _$ScheduleInstanceMemberReplyImpl>
    implements _$$ScheduleInstanceMemberReplyImplCopyWith<$Res> {
  __$$ScheduleInstanceMemberReplyImplCopyWithImpl(
      _$ScheduleInstanceMemberReplyImpl _value,
      $Res Function(_$ScheduleInstanceMemberReplyImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? member = null,
    Object? reply = freezed,
    Object? defaultReply = freezed,
    Object? defaultRule = freezed,
    Object? profile = freezed,
  }) {
    return _then(_$ScheduleInstanceMemberReplyImpl(
      member: null == member
          ? _value.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member,
      reply: freezed == reply
          ? _value.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultReply: freezed == defaultReply
          ? _value.defaultReply
          : defaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultRule: freezed == defaultRule
          ? _value.defaultRule
          : defaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }
}

/// @nodoc

class _$ScheduleInstanceMemberReplyImpl
    with DiagnosticableTreeMixin
    implements _ScheduleInstanceMemberReply {
  const _$ScheduleInstanceMemberReplyImpl(
      {required this.member,
      this.reply,
      this.defaultReply,
      this.defaultRule,
      this.profile});

  @override
  final Member member;
  @override
  final ReplyOptions? reply;
  @override
  final ReplyOptions? defaultReply;
  @override
  final DefaultRule? defaultRule;
  @override
  final Profile? profile;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceMember(member: $member, reply: $reply, defaultReply: $defaultReply, defaultRule: $defaultRule, profile: $profile)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceMember'))
      ..add(DiagnosticsProperty('member', member))
      ..add(DiagnosticsProperty('reply', reply))
      ..add(DiagnosticsProperty('defaultReply', defaultReply))
      ..add(DiagnosticsProperty('defaultRule', defaultRule))
      ..add(DiagnosticsProperty('profile', profile));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleInstanceMemberReplyImpl &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.defaultReply, defaultReply) ||
                other.defaultReply == defaultReply) &&
            (identical(other.defaultRule, defaultRule) ||
                other.defaultRule == defaultRule) &&
            (identical(other.profile, profile) || other.profile == profile));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, member, reply, defaultReply, defaultRule, profile);

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleInstanceMemberReplyImplCopyWith<_$ScheduleInstanceMemberReplyImpl>
      get copyWith => __$$ScheduleInstanceMemberReplyImplCopyWithImpl<
          _$ScheduleInstanceMemberReplyImpl>(this, _$identity);
}

abstract class _ScheduleInstanceMemberReply implements ScheduleInstanceMember {
  const factory _ScheduleInstanceMemberReply(
      {required final Member member,
      final ReplyOptions? reply,
      final ReplyOptions? defaultReply,
      final DefaultRule? defaultRule,
      final Profile? profile}) = _$ScheduleInstanceMemberReplyImpl;

  @override
  Member get member;
  @override
  ReplyOptions? get reply;
  @override
  ReplyOptions? get defaultReply;
  @override
  DefaultRule? get defaultRule;
  @override
  Profile? get profile;

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleInstanceMemberReplyImplCopyWith<_$ScheduleInstanceMemberReplyImpl>
      get copyWith => throw _privateConstructorUsedError;
}
