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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DefaultRule _$DefaultRuleFromJson(Map<String, dynamic> json) {
  return _DefaultRule.fromJson(json);
}

/// @nodoc
mixin _$DefaultRule {
  int get memberId => throw _privateConstructorUsedError;

  int get scheduleId => throw _privateConstructorUsedError;

  ReplyOptions get selectedOption => throw _privateConstructorUsedError;

  RecurrenceRule get recurrenceRule => throw _privateConstructorUsedError;

  DateTime? get createdAt => throw _privateConstructorUsedError;

  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DefaultRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DefaultRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefaultRuleCopyWith<DefaultRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefaultRuleCopyWith<$Res> {
  factory $DefaultRuleCopyWith(
          DefaultRule value, $Res Function(DefaultRule) then) =
      _$DefaultRuleCopyWithImpl<$Res, DefaultRule>;

  @useResult
  $Res call(
      {int memberId,
      int scheduleId,
      ReplyOptions selectedOption,
      RecurrenceRule recurrenceRule,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$DefaultRuleCopyWithImpl<$Res, $Val extends DefaultRule>
    implements $DefaultRuleCopyWith<$Res> {
  _$DefaultRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefaultRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? scheduleId = null,
    Object? selectedOption = null,
    Object? recurrenceRule = null,
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
      selectedOption: null == selectedOption
          ? _value.selectedOption
          : selectedOption // ignore: cast_nullable_to_non_nullable
              as ReplyOptions,
      recurrenceRule: null == recurrenceRule
          ? _value.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as RecurrenceRule,
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
abstract class _$$DefaultRuleImplCopyWith<$Res>
    implements $DefaultRuleCopyWith<$Res> {
  factory _$$DefaultRuleImplCopyWith(
          _$DefaultRuleImpl value, $Res Function(_$DefaultRuleImpl) then) =
      __$$DefaultRuleImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int memberId,
      int scheduleId,
      ReplyOptions selectedOption,
      RecurrenceRule recurrenceRule,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$DefaultRuleImplCopyWithImpl<$Res>
    extends _$DefaultRuleCopyWithImpl<$Res, _$DefaultRuleImpl>
    implements _$$DefaultRuleImplCopyWith<$Res> {
  __$$DefaultRuleImplCopyWithImpl(
      _$DefaultRuleImpl _value, $Res Function(_$DefaultRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DefaultRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = null,
    Object? scheduleId = null,
    Object? selectedOption = null,
    Object? recurrenceRule = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$DefaultRuleImpl(
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
class _$DefaultRuleImpl with DiagnosticableTreeMixin implements _DefaultRule {
  const _$DefaultRuleImpl(
      {required this.memberId,
      required this.scheduleId,
      required this.selectedOption,
      required this.recurrenceRule,
      this.createdAt,
      this.updatedAt});

  factory _$DefaultRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefaultRuleImplFromJson(json);

  @override
  final int memberId;
  @override
  final int scheduleId;
  @override
  final ReplyOptions selectedOption;
  @override
  final RecurrenceRule recurrenceRule;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DefaultRule(memberId: $memberId, scheduleId: $scheduleId, selectedOption: $selectedOption, recurrenceRule: $recurrenceRule, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DefaultRule'))
      ..add(DiagnosticsProperty('memberId', memberId))
      ..add(DiagnosticsProperty('scheduleId', scheduleId))
      ..add(DiagnosticsProperty('selectedOption', selectedOption))
      ..add(DiagnosticsProperty('recurrenceRule', recurrenceRule))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefaultRuleImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.scheduleId, scheduleId) ||
                other.scheduleId == scheduleId) &&
            (identical(other.selectedOption, selectedOption) ||
                other.selectedOption == selectedOption) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberId, scheduleId,
      selectedOption, recurrenceRule, createdAt, updatedAt);

  /// Create a copy of DefaultRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefaultRuleImplCopyWith<_$DefaultRuleImpl> get copyWith =>
      __$$DefaultRuleImplCopyWithImpl<_$DefaultRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefaultRuleImplToJson(
      this,
    );
  }
}

abstract class _DefaultRule implements DefaultRule {
  const factory _DefaultRule(
      {required final int memberId,
      required final int scheduleId,
      required final ReplyOptions selectedOption,
      required final RecurrenceRule recurrenceRule,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$DefaultRuleImpl;

  factory _DefaultRule.fromJson(Map<String, dynamic> json) =
      _$DefaultRuleImpl.fromJson;

  @override
  int get memberId;

  @override
  int get scheduleId;

  @override
  ReplyOptions get selectedOption;

  @override
  RecurrenceRule get recurrenceRule;

  @override
  DateTime? get createdAt;

  @override
  DateTime? get updatedAt;

  /// Create a copy of DefaultRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefaultRuleImplCopyWith<_$DefaultRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
