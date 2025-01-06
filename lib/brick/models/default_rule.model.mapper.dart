// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'default_rule.model.dart';

class DefaultRuleMapper extends ClassMapperBase<DefaultRule> {
  DefaultRuleMapper._();

  static DefaultRuleMapper? _instance;
  static DefaultRuleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DefaultRuleMapper._());
      MemberMapper.ensureInitialized();
      ScheduleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DefaultRule';

  static Member _$member(DefaultRule v) => v.member;
  static const Field<DefaultRule, Member> _f$member = Field('member', _$member);
  static Schedule _$schedule(DefaultRule v) => v.schedule;
  static const Field<DefaultRule, Schedule> _f$schedule =
      Field('schedule', _$schedule);
  static ReplyOptions _$selectedOption(DefaultRule v) => v.selectedOption;
  static const Field<DefaultRule, ReplyOptions> _f$selectedOption =
      Field('selectedOption', _$selectedOption);
  static RecurrenceRule _$recurrenceRule(DefaultRule v) => v.recurrenceRule;
  static const Field<DefaultRule, RecurrenceRule> _f$recurrenceRule =
      Field('recurrenceRule', _$recurrenceRule);
  static DateTime? _$createdAt(DefaultRule v) => v.createdAt;
  static const Field<DefaultRule, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);
  static DateTime? _$updatedAt(DefaultRule v) => v.updatedAt;
  static const Field<DefaultRule, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);

  @override
  final MappableFields<DefaultRule> fields = const {
    #member: _f$member,
    #schedule: _f$schedule,
    #selectedOption: _f$selectedOption,
    #recurrenceRule: _f$recurrenceRule,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static DefaultRule _instantiate(DecodingData data) {
    return DefaultRule(
        member: data.dec(_f$member),
        schedule: data.dec(_f$schedule),
        selectedOption: data.dec(_f$selectedOption),
        recurrenceRule: data.dec(_f$recurrenceRule),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static DefaultRule fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DefaultRule>(map);
  }

  static DefaultRule fromJson(String json) {
    return ensureInitialized().decodeJson<DefaultRule>(json);
  }
}

mixin DefaultRuleMappable {
  String toJson() {
    return DefaultRuleMapper.ensureInitialized()
        .encodeJson<DefaultRule>(this as DefaultRule);
  }

  Map<String, dynamic> toMap() {
    return DefaultRuleMapper.ensureInitialized()
        .encodeMap<DefaultRule>(this as DefaultRule);
  }

  DefaultRuleCopyWith<DefaultRule, DefaultRule, DefaultRule> get copyWith =>
      _DefaultRuleCopyWithImpl(this as DefaultRule, $identity, $identity);
  @override
  String toString() {
    return DefaultRuleMapper.ensureInitialized()
        .stringifyValue(this as DefaultRule);
  }

  @override
  bool operator ==(Object other) {
    return DefaultRuleMapper.ensureInitialized()
        .equalsValue(this as DefaultRule, other);
  }

  @override
  int get hashCode {
    return DefaultRuleMapper.ensureInitialized().hashValue(this as DefaultRule);
  }
}

extension DefaultRuleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DefaultRule, $Out> {
  DefaultRuleCopyWith<$R, DefaultRule, $Out> get $asDefaultRule =>
      $base.as((v, t, t2) => _DefaultRuleCopyWithImpl(v, t, t2));
}

abstract class DefaultRuleCopyWith<$R, $In extends DefaultRule, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MemberCopyWith<$R, Member, Member> get member;
  ScheduleCopyWith<$R, Schedule, Schedule> get schedule;
  $R call(
      {Member? member,
      Schedule? schedule,
      ReplyOptions? selectedOption,
      RecurrenceRule? recurrenceRule,
      DateTime? createdAt,
      DateTime? updatedAt});
  DefaultRuleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DefaultRuleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DefaultRule, $Out>
    implements DefaultRuleCopyWith<$R, DefaultRule, $Out> {
  _DefaultRuleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DefaultRule> $mapper =
      DefaultRuleMapper.ensureInitialized();
  @override
  MemberCopyWith<$R, Member, Member> get member =>
      $value.member.copyWith.$chain((v) => call(member: v));
  @override
  ScheduleCopyWith<$R, Schedule, Schedule> get schedule =>
      $value.schedule.copyWith.$chain((v) => call(schedule: v));
  @override
  $R call(
          {Member? member,
          Schedule? schedule,
          ReplyOptions? selectedOption,
          RecurrenceRule? recurrenceRule,
          Object? createdAt = $none,
          Object? updatedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (member != null) #member: member,
        if (schedule != null) #schedule: schedule,
        if (selectedOption != null) #selectedOption: selectedOption,
        if (recurrenceRule != null) #recurrenceRule: recurrenceRule,
        if (createdAt != $none) #createdAt: createdAt,
        if (updatedAt != $none) #updatedAt: updatedAt
      }));
  @override
  DefaultRule $make(CopyWithData data) => DefaultRule(
      member: data.get(#member, or: $value.member),
      schedule: data.get(#schedule, or: $value.schedule),
      selectedOption: data.get(#selectedOption, or: $value.selectedOption),
      recurrenceRule: data.get(#recurrenceRule, or: $value.recurrenceRule),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  DefaultRuleCopyWith<$R2, DefaultRule, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DefaultRuleCopyWithImpl($value, $cast, t);
}
