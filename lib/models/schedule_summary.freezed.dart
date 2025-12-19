// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleInstanceSummary implements DiagnosticableTreeMixin {
  String get scheduleId;
  String get groupId;
  String get displayName;
  DateTime get instanceDate;
  Map<String, ReplyOptions> get memberReplies;
  Map<String, ReplyOptions> get memberDefaultReplies;
  Map<String, DefaultRule> get memberDefaultRules;
  int get yesCount;
  ReplyOptions? get myReply;
  ReplyOptions? get myDefaultReply;
  DefaultRule? get myDefaultRule;
  String? get targetMemberId;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleInstanceSummaryCopyWith<ScheduleInstanceSummary> get copyWith =>
      _$ScheduleInstanceSummaryCopyWithImpl<ScheduleInstanceSummary>(
          this as ScheduleInstanceSummary, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('myDefaultRule', myDefaultRule))
      ..add(DiagnosticsProperty('targetMemberId', targetMemberId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduleInstanceSummary &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            const DeepCollectionEquality()
                .equals(other.memberReplies, memberReplies) &&
            const DeepCollectionEquality()
                .equals(other.memberDefaultReplies, memberDefaultReplies) &&
            const DeepCollectionEquality()
                .equals(other.memberDefaultRules, memberDefaultRules) &&
            (identical(other.yesCount, yesCount) ||
                other.yesCount == yesCount) &&
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
      const DeepCollectionEquality().hash(memberReplies),
      const DeepCollectionEquality().hash(memberDefaultReplies),
      const DeepCollectionEquality().hash(memberDefaultRules),
      yesCount,
      myReply,
      myDefaultReply,
      myDefaultRule,
      targetMemberId);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceSummary(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, memberReplies: $memberReplies, memberDefaultReplies: $memberDefaultReplies, memberDefaultRules: $memberDefaultRules, yesCount: $yesCount, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId)';
  }
}

/// @nodoc
abstract mixin class $ScheduleInstanceSummaryCopyWith<$Res> {
  factory $ScheduleInstanceSummaryCopyWith(ScheduleInstanceSummary value,
          $Res Function(ScheduleInstanceSummary) _then) =
      _$ScheduleInstanceSummaryCopyWithImpl;
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
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId});

  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
}

/// @nodoc
class _$ScheduleInstanceSummaryCopyWithImpl<$Res>
    implements $ScheduleInstanceSummaryCopyWith<$Res> {
  _$ScheduleInstanceSummaryCopyWithImpl(this._self, this._then);

  final ScheduleInstanceSummary _self;
  final $Res Function(ScheduleInstanceSummary) _then;

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
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_self.copyWith(
      scheduleId: null == scheduleId
          ? _self.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _self.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberReplies: null == memberReplies
          ? _self.memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _self.memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultRules: null == memberDefaultRules
          ? _self.memberDefaultRules
          : memberDefaultRules // ignore: cast_nullable_to_non_nullable
              as Map<String, DefaultRule>,
      yesCount: null == yesCount
          ? _self.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _self.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _self.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _self.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_self.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.myDefaultRule!, (value) {
      return _then(_self.copyWith(myDefaultRule: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ScheduleInstanceSummary].
extension ScheduleInstanceSummaryPatterns on ScheduleInstanceSummary {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScheduleInstanceSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScheduleInstanceSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScheduleInstanceSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            Map<String, ReplyOptions> memberReplies,
            Map<String, ReplyOptions> memberDefaultReplies,
            Map<String, DefaultRule> memberDefaultRules,
            int yesCount,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary() when $default != null:
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.memberReplies,
            _that.memberDefaultReplies,
            _that.memberDefaultRules,
            _that.yesCount,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            Map<String, ReplyOptions> memberReplies,
            Map<String, ReplyOptions> memberDefaultReplies,
            Map<String, DefaultRule> memberDefaultRules,
            int yesCount,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary():
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.memberReplies,
            _that.memberDefaultReplies,
            _that.memberDefaultRules,
            _that.yesCount,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            Map<String, ReplyOptions> memberReplies,
            Map<String, ReplyOptions> memberDefaultReplies,
            Map<String, DefaultRule> memberDefaultRules,
            int yesCount,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceSummary() when $default != null:
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.memberReplies,
            _that.memberDefaultReplies,
            _that.memberDefaultRules,
            _that.yesCount,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScheduleInstanceSummary
    with DiagnosticableTreeMixin
    implements ScheduleInstanceSummary {
  const _ScheduleInstanceSummary(
      {required this.scheduleId,
      required this.groupId,
      required this.displayName,
      required this.instanceDate,
      required final Map<String, ReplyOptions> memberReplies,
      required final Map<String, ReplyOptions> memberDefaultReplies,
      required final Map<String, DefaultRule> memberDefaultRules,
      required this.yesCount,
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
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReply;
  @override
  final DefaultRule? myDefaultRule;
  @override
  final String? targetMemberId;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleInstanceSummaryCopyWith<_ScheduleInstanceSummary> get copyWith =>
      __$ScheduleInstanceSummaryCopyWithImpl<_ScheduleInstanceSummary>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
      ..add(DiagnosticsProperty('myReply', myReply))
      ..add(DiagnosticsProperty('myDefaultReply', myDefaultReply))
      ..add(DiagnosticsProperty('myDefaultRule', myDefaultRule))
      ..add(DiagnosticsProperty('targetMemberId', targetMemberId));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScheduleInstanceSummary &&
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
      myReply,
      myDefaultReply,
      myDefaultRule,
      targetMemberId);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceSummary(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, memberReplies: $memberReplies, memberDefaultReplies: $memberDefaultReplies, memberDefaultRules: $memberDefaultRules, yesCount: $yesCount, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleInstanceSummaryCopyWith<$Res>
    implements $ScheduleInstanceSummaryCopyWith<$Res> {
  factory _$ScheduleInstanceSummaryCopyWith(_ScheduleInstanceSummary value,
          $Res Function(_ScheduleInstanceSummary) _then) =
      __$ScheduleInstanceSummaryCopyWithImpl;
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
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId});

  @override
  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
}

/// @nodoc
class __$ScheduleInstanceSummaryCopyWithImpl<$Res>
    implements _$ScheduleInstanceSummaryCopyWith<$Res> {
  __$ScheduleInstanceSummaryCopyWithImpl(this._self, this._then);

  final _ScheduleInstanceSummary _self;
  final $Res Function(_ScheduleInstanceSummary) _then;

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? memberReplies = null,
    Object? memberDefaultReplies = null,
    Object? memberDefaultRules = null,
    Object? yesCount = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
  }) {
    return _then(_ScheduleInstanceSummary(
      scheduleId: null == scheduleId
          ? _self.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _self.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberReplies: null == memberReplies
          ? _self._memberReplies
          : memberReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultReplies: null == memberDefaultReplies
          ? _self._memberDefaultReplies
          : memberDefaultReplies // ignore: cast_nullable_to_non_nullable
              as Map<String, ReplyOptions>,
      memberDefaultRules: null == memberDefaultRules
          ? _self._memberDefaultRules
          : memberDefaultRules // ignore: cast_nullable_to_non_nullable
              as Map<String, DefaultRule>,
      yesCount: null == yesCount
          ? _self.yesCount
          : yesCount // ignore: cast_nullable_to_non_nullable
              as int,
      myReply: freezed == myReply
          ? _self.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _self.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _self.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of ScheduleInstanceSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_self.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.myDefaultRule!, (value) {
      return _then(_self.copyWith(myDefaultRule: value));
    });
  }
}

/// @nodoc
mixin _$ScheduleInstanceDetails implements DiagnosticableTreeMixin {
  String get scheduleId;
  String get groupId;
  String get displayName;
  DateTime get instanceDate;
  List<ScheduleInstanceRepliesGroup> get repliesGroups;
  ReplyOptions? get myReply;
  ReplyOptions? get myDefaultReply;
  DefaultRule? get myDefaultRule;
  String? get targetMemberId;
  bool? get canEditOthers;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleInstanceDetailsCopyWith<ScheduleInstanceDetails> get copyWith =>
      _$ScheduleInstanceDetailsCopyWithImpl<ScheduleInstanceDetails>(
          this as ScheduleInstanceDetails, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceDetails'))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('groupId', groupId))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('instanceDate', instanceDate))
      ..add(DiagnosticsProperty('repliesGroups', repliesGroups))
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
            other is ScheduleInstanceDetails &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            const DeepCollectionEquality()
                .equals(other.repliesGroups, repliesGroups) &&
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
      const DeepCollectionEquality().hash(repliesGroups),
      myReply,
      myDefaultReply,
      myDefaultRule,
      targetMemberId,
      canEditOthers);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceDetails(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, repliesGroups: $repliesGroups, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId, canEditOthers: $canEditOthers)';
  }
}

/// @nodoc
abstract mixin class $ScheduleInstanceDetailsCopyWith<$Res> {
  factory $ScheduleInstanceDetailsCopyWith(ScheduleInstanceDetails value,
          $Res Function(ScheduleInstanceDetails) _then) =
      _$ScheduleInstanceDetailsCopyWithImpl;
  @useResult
  $Res call(
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      List<ScheduleInstanceRepliesGroup> repliesGroups,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId,
      bool? canEditOthers});

  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
}

/// @nodoc
class _$ScheduleInstanceDetailsCopyWithImpl<$Res>
    implements $ScheduleInstanceDetailsCopyWith<$Res> {
  _$ScheduleInstanceDetailsCopyWithImpl(this._self, this._then);

  final ScheduleInstanceDetails _self;
  final $Res Function(ScheduleInstanceDetails) _then;

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
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_self.copyWith(
      scheduleId: null == scheduleId
          ? _self.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _self.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repliesGroups: null == repliesGroups
          ? _self.repliesGroups
          : repliesGroups // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceRepliesGroup>,
      myReply: freezed == myReply
          ? _self.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _self.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _self.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      canEditOthers: freezed == canEditOthers
          ? _self.canEditOthers
          : canEditOthers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_self.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.myDefaultRule!, (value) {
      return _then(_self.copyWith(myDefaultRule: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ScheduleInstanceDetails].
extension ScheduleInstanceDetailsPatterns on ScheduleInstanceDetails {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScheduleInstanceDetails value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScheduleInstanceDetails value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScheduleInstanceDetails value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            List<ScheduleInstanceRepliesGroup> repliesGroups,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId,
            bool? canEditOthers)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails() when $default != null:
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.repliesGroups,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId,
            _that.canEditOthers);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            List<ScheduleInstanceRepliesGroup> repliesGroups,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId,
            bool? canEditOthers)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails():
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.repliesGroups,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId,
            _that.canEditOthers);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String scheduleId,
            String groupId,
            String displayName,
            DateTime instanceDate,
            List<ScheduleInstanceRepliesGroup> repliesGroups,
            ReplyOptions? myReply,
            ReplyOptions? myDefaultReply,
            DefaultRule? myDefaultRule,
            String? targetMemberId,
            bool? canEditOthers)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceDetails() when $default != null:
        return $default(
            _that.scheduleId,
            _that.groupId,
            _that.displayName,
            _that.instanceDate,
            _that.repliesGroups,
            _that.myReply,
            _that.myDefaultReply,
            _that.myDefaultRule,
            _that.targetMemberId,
            _that.canEditOthers);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScheduleInstanceDetails
    with DiagnosticableTreeMixin
    implements ScheduleInstanceDetails {
  const _ScheduleInstanceDetails(
      {required this.scheduleId,
      required this.groupId,
      required this.displayName,
      required this.instanceDate,
      required final List<ScheduleInstanceRepliesGroup> repliesGroups,
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
  final ReplyOptions? myReply;
  @override
  final ReplyOptions? myDefaultReply;
  @override
  final DefaultRule? myDefaultRule;
  @override
  final String? targetMemberId;
  @override
  final bool? canEditOthers;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleInstanceDetailsCopyWith<_ScheduleInstanceDetails> get copyWith =>
      __$ScheduleInstanceDetailsCopyWithImpl<_ScheduleInstanceDetails>(
          this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleInstanceDetails'))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('groupId', groupId))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('instanceDate', instanceDate))
      ..add(DiagnosticsProperty('repliesGroups', repliesGroups))
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
            other is _ScheduleInstanceDetails &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.instanceDate, instanceDate) ||
                other.instanceDate == instanceDate) &&
            const DeepCollectionEquality()
                .equals(other._repliesGroups, _repliesGroups) &&
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
      myReply,
      myDefaultReply,
      myDefaultRule,
      targetMemberId,
      canEditOthers);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceDetails(scheduleId: $scheduleId, groupId: $groupId, displayName: $displayName, instanceDate: $instanceDate, repliesGroups: $repliesGroups, myReply: $myReply, myDefaultReply: $myDefaultReply, myDefaultRule: $myDefaultRule, targetMemberId: $targetMemberId, canEditOthers: $canEditOthers)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleInstanceDetailsCopyWith<$Res>
    implements $ScheduleInstanceDetailsCopyWith<$Res> {
  factory _$ScheduleInstanceDetailsCopyWith(_ScheduleInstanceDetails value,
          $Res Function(_ScheduleInstanceDetails) _then) =
      __$ScheduleInstanceDetailsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String scheduleId,
      String groupId,
      String displayName,
      DateTime instanceDate,
      List<ScheduleInstanceRepliesGroup> repliesGroups,
      ReplyOptions? myReply,
      ReplyOptions? myDefaultReply,
      DefaultRule? myDefaultRule,
      String? targetMemberId,
      bool? canEditOthers});

  @override
  $DefaultRuleCopyWith<$Res>? get myDefaultRule;
}

/// @nodoc
class __$ScheduleInstanceDetailsCopyWithImpl<$Res>
    implements _$ScheduleInstanceDetailsCopyWith<$Res> {
  __$ScheduleInstanceDetailsCopyWithImpl(this._self, this._then);

  final _ScheduleInstanceDetails _self;
  final $Res Function(_ScheduleInstanceDetails) _then;

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? scheduleId = null,
    Object? groupId = null,
    Object? displayName = null,
    Object? instanceDate = null,
    Object? repliesGroups = null,
    Object? myReply = freezed,
    Object? myDefaultReply = freezed,
    Object? myDefaultRule = freezed,
    Object? targetMemberId = freezed,
    Object? canEditOthers = freezed,
  }) {
    return _then(_ScheduleInstanceDetails(
      scheduleId: null == scheduleId
          ? _self.scheduleId
          : scheduleId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _self.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      instanceDate: null == instanceDate
          ? _self.instanceDate
          : instanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repliesGroups: null == repliesGroups
          ? _self._repliesGroups
          : repliesGroups // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceRepliesGroup>,
      myReply: freezed == myReply
          ? _self.myReply
          : myReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultReply: freezed == myDefaultReply
          ? _self.myDefaultReply
          : myDefaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      myDefaultRule: freezed == myDefaultRule
          ? _self.myDefaultRule
          : myDefaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      targetMemberId: freezed == targetMemberId
          ? _self.targetMemberId
          : targetMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      canEditOthers: freezed == canEditOthers
          ? _self.canEditOthers
          : canEditOthers // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }

  /// Create a copy of ScheduleInstanceDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get myDefaultRule {
    if (_self.myDefaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.myDefaultRule!, (value) {
      return _then(_self.copyWith(myDefaultRule: value));
    });
  }
}

/// @nodoc
mixin _$ScheduleInstanceRepliesGroup implements DiagnosticableTreeMixin {
  ReplyOptions? get reply;
  int get count;
  List<ScheduleInstanceMember> get members;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleInstanceRepliesGroupCopyWith<ScheduleInstanceRepliesGroup>
      get copyWith => _$ScheduleInstanceRepliesGroupCopyWithImpl<
              ScheduleInstanceRepliesGroup>(
          this as ScheduleInstanceRepliesGroup, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is ScheduleInstanceRepliesGroup &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, reply, count, const DeepCollectionEquality().hash(members));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceRepliesGroup(reply: $reply, count: $count, members: $members)';
  }
}

/// @nodoc
abstract mixin class $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  factory $ScheduleInstanceRepliesGroupCopyWith(
          ScheduleInstanceRepliesGroup value,
          $Res Function(ScheduleInstanceRepliesGroup) _then) =
      _$ScheduleInstanceRepliesGroupCopyWithImpl;
  @useResult
  $Res call(
      {ReplyOptions? reply, int count, List<ScheduleInstanceMember> members});
}

/// @nodoc
class _$ScheduleInstanceRepliesGroupCopyWithImpl<$Res>
    implements $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  _$ScheduleInstanceRepliesGroupCopyWithImpl(this._self, this._then);

  final ScheduleInstanceRepliesGroup _self;
  final $Res Function(ScheduleInstanceRepliesGroup) _then;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reply = freezed,
    Object? count = null,
    Object? members = null,
  }) {
    return _then(_self.copyWith(
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceMember>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScheduleInstanceRepliesGroup].
extension ScheduleInstanceRepliesGroupPatterns on ScheduleInstanceRepliesGroup {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScheduleInstanceRepliesGroup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScheduleInstanceRepliesGroup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScheduleInstanceRepliesGroup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(ReplyOptions? reply, int count,
            List<ScheduleInstanceMember> members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup() when $default != null:
        return $default(_that.reply, _that.count, _that.members);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(ReplyOptions? reply, int count,
            List<ScheduleInstanceMember> members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup():
        return $default(_that.reply, _that.count, _that.members);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(ReplyOptions? reply, int count,
            List<ScheduleInstanceMember> members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceRepliesGroup() when $default != null:
        return $default(_that.reply, _that.count, _that.members);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScheduleInstanceRepliesGroup
    with DiagnosticableTreeMixin
    implements ScheduleInstanceRepliesGroup {
  const _ScheduleInstanceRepliesGroup(
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

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleInstanceRepliesGroupCopyWith<_ScheduleInstanceRepliesGroup>
      get copyWith => __$ScheduleInstanceRepliesGroupCopyWithImpl<
          _ScheduleInstanceRepliesGroup>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _ScheduleInstanceRepliesGroup &&
            (identical(other.reply, reply) || other.reply == reply) &&
            (identical(other.count, count) || other.count == count) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, reply, count, const DeepCollectionEquality().hash(_members));

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceRepliesGroup(reply: $reply, count: $count, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleInstanceRepliesGroupCopyWith<$Res>
    implements $ScheduleInstanceRepliesGroupCopyWith<$Res> {
  factory _$ScheduleInstanceRepliesGroupCopyWith(
          _ScheduleInstanceRepliesGroup value,
          $Res Function(_ScheduleInstanceRepliesGroup) _then) =
      __$ScheduleInstanceRepliesGroupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ReplyOptions? reply, int count, List<ScheduleInstanceMember> members});
}

/// @nodoc
class __$ScheduleInstanceRepliesGroupCopyWithImpl<$Res>
    implements _$ScheduleInstanceRepliesGroupCopyWith<$Res> {
  __$ScheduleInstanceRepliesGroupCopyWithImpl(this._self, this._then);

  final _ScheduleInstanceRepliesGroup _self;
  final $Res Function(_ScheduleInstanceRepliesGroup) _then;

  /// Create a copy of ScheduleInstanceRepliesGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reply = freezed,
    Object? count = null,
    Object? members = null,
  }) {
    return _then(_ScheduleInstanceRepliesGroup(
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ScheduleInstanceMember>,
    ));
  }
}

/// @nodoc
mixin _$ScheduleInstanceMember implements DiagnosticableTreeMixin {
  Member get member;
  ReplyOptions? get reply;
  ReplyOptions? get defaultReply;
  DefaultRule? get defaultRule;
  Profile? get profile;

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduleInstanceMemberCopyWith<ScheduleInstanceMember> get copyWith =>
      _$ScheduleInstanceMemberCopyWithImpl<ScheduleInstanceMember>(
          this as ScheduleInstanceMember, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is ScheduleInstanceMember &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceMember(member: $member, reply: $reply, defaultReply: $defaultReply, defaultRule: $defaultRule, profile: $profile)';
  }
}

/// @nodoc
abstract mixin class $ScheduleInstanceMemberCopyWith<$Res> {
  factory $ScheduleInstanceMemberCopyWith(ScheduleInstanceMember value,
          $Res Function(ScheduleInstanceMember) _then) =
      _$ScheduleInstanceMemberCopyWithImpl;
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
class _$ScheduleInstanceMemberCopyWithImpl<$Res>
    implements $ScheduleInstanceMemberCopyWith<$Res> {
  _$ScheduleInstanceMemberCopyWithImpl(this._self, this._then);

  final ScheduleInstanceMember _self;
  final $Res Function(ScheduleInstanceMember) _then;

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
    return _then(_self.copyWith(
      member: null == member
          ? _self.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member,
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultReply: freezed == defaultReply
          ? _self.defaultReply
          : defaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultRule: freezed == defaultRule
          ? _self.defaultRule
          : defaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      profile: freezed == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get member {
    return $MemberCopyWith<$Res>(_self.member, (value) {
      return _then(_self.copyWith(member: value));
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get defaultRule {
    if (_self.defaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.defaultRule!, (value) {
      return _then(_self.copyWith(defaultRule: value));
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_self.profile!, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ScheduleInstanceMember].
extension ScheduleInstanceMemberPatterns on ScheduleInstanceMember {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScheduleInstanceMemberReply value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScheduleInstanceMemberReply value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScheduleInstanceMemberReply value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            Member member,
            ReplyOptions? reply,
            ReplyOptions? defaultReply,
            DefaultRule? defaultRule,
            Profile? profile)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply() when $default != null:
        return $default(_that.member, _that.reply, _that.defaultReply,
            _that.defaultRule, _that.profile);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            Member member,
            ReplyOptions? reply,
            ReplyOptions? defaultReply,
            DefaultRule? defaultRule,
            Profile? profile)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply():
        return $default(_that.member, _that.reply, _that.defaultReply,
            _that.defaultRule, _that.profile);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            Member member,
            ReplyOptions? reply,
            ReplyOptions? defaultReply,
            DefaultRule? defaultRule,
            Profile? profile)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScheduleInstanceMemberReply() when $default != null:
        return $default(_that.member, _that.reply, _that.defaultReply,
            _that.defaultRule, _that.profile);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ScheduleInstanceMemberReply
    with DiagnosticableTreeMixin
    implements ScheduleInstanceMember {
  const _ScheduleInstanceMemberReply(
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

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScheduleInstanceMemberReplyCopyWith<_ScheduleInstanceMemberReply>
      get copyWith => __$ScheduleInstanceMemberReplyCopyWithImpl<
          _ScheduleInstanceMemberReply>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
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
            other is _ScheduleInstanceMemberReply &&
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

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleInstanceMember(member: $member, reply: $reply, defaultReply: $defaultReply, defaultRule: $defaultRule, profile: $profile)';
  }
}

/// @nodoc
abstract mixin class _$ScheduleInstanceMemberReplyCopyWith<$Res>
    implements $ScheduleInstanceMemberCopyWith<$Res> {
  factory _$ScheduleInstanceMemberReplyCopyWith(
          _ScheduleInstanceMemberReply value,
          $Res Function(_ScheduleInstanceMemberReply) _then) =
      __$ScheduleInstanceMemberReplyCopyWithImpl;
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
class __$ScheduleInstanceMemberReplyCopyWithImpl<$Res>
    implements _$ScheduleInstanceMemberReplyCopyWith<$Res> {
  __$ScheduleInstanceMemberReplyCopyWithImpl(this._self, this._then);

  final _ScheduleInstanceMemberReply _self;
  final $Res Function(_ScheduleInstanceMemberReply) _then;

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? member = null,
    Object? reply = freezed,
    Object? defaultReply = freezed,
    Object? defaultRule = freezed,
    Object? profile = freezed,
  }) {
    return _then(_ScheduleInstanceMemberReply(
      member: null == member
          ? _self.member
          : member // ignore: cast_nullable_to_non_nullable
              as Member,
      reply: freezed == reply
          ? _self.reply
          : reply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultReply: freezed == defaultReply
          ? _self.defaultReply
          : defaultReply // ignore: cast_nullable_to_non_nullable
              as ReplyOptions?,
      defaultRule: freezed == defaultRule
          ? _self.defaultRule
          : defaultRule // ignore: cast_nullable_to_non_nullable
              as DefaultRule?,
      profile: freezed == profile
          ? _self.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
    ));
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res> get member {
    return $MemberCopyWith<$Res>(_self.member, (value) {
      return _then(_self.copyWith(member: value));
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DefaultRuleCopyWith<$Res>? get defaultRule {
    if (_self.defaultRule == null) {
      return null;
    }

    return $DefaultRuleCopyWith<$Res>(_self.defaultRule!, (value) {
      return _then(_self.copyWith(defaultRule: value));
    });
  }

  /// Create a copy of ScheduleInstanceMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_self.profile!, (value) {
      return _then(_self.copyWith(profile: value));
    });
  }
}

// dart format on
