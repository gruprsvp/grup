// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'reply.model.dart';

class ReplyMapper extends ClassMapperBase<Reply> {
  ReplyMapper._();

  static ReplyMapper? _instance;
  static ReplyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplyMapper._());
      MemberMapper.ensureInitialized();
      ScheduleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Reply';

  static Member _$member(Reply v) => v.member;
  static const Field<Reply, Member> _f$member = Field('member', _$member);
  static Schedule _$schedule(Reply v) => v.schedule;
  static const Field<Reply, Schedule> _f$schedule =
      Field('schedule', _$schedule);
  static DateTime _$instanceDate(Reply v) => v.instanceDate;
  static const Field<Reply, DateTime> _f$instanceDate =
      Field('instanceDate', _$instanceDate);
  static ReplyOptions _$selectedOption(Reply v) => v.selectedOption;
  static const Field<Reply, ReplyOptions> _f$selectedOption =
      Field('selectedOption', _$selectedOption);
  static DateTime? _$createdAt(Reply v) => v.createdAt;
  static const Field<Reply, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);
  static DateTime? _$updatedAt(Reply v) => v.updatedAt;
  static const Field<Reply, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);

  @override
  final MappableFields<Reply> fields = const {
    #member: _f$member,
    #schedule: _f$schedule,
    #instanceDate: _f$instanceDate,
    #selectedOption: _f$selectedOption,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static Reply _instantiate(DecodingData data) {
    return Reply(
        member: data.dec(_f$member),
        schedule: data.dec(_f$schedule),
        instanceDate: data.dec(_f$instanceDate),
        selectedOption: data.dec(_f$selectedOption),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static Reply fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Reply>(map);
  }

  static Reply fromJson(String json) {
    return ensureInitialized().decodeJson<Reply>(json);
  }
}

mixin ReplyMappable {
  String toJson() {
    return ReplyMapper.ensureInitialized().encodeJson<Reply>(this as Reply);
  }

  Map<String, dynamic> toMap() {
    return ReplyMapper.ensureInitialized().encodeMap<Reply>(this as Reply);
  }

  ReplyCopyWith<Reply, Reply, Reply> get copyWith =>
      _ReplyCopyWithImpl(this as Reply, $identity, $identity);
  @override
  String toString() {
    return ReplyMapper.ensureInitialized().stringifyValue(this as Reply);
  }

  @override
  bool operator ==(Object other) {
    return ReplyMapper.ensureInitialized().equalsValue(this as Reply, other);
  }

  @override
  int get hashCode {
    return ReplyMapper.ensureInitialized().hashValue(this as Reply);
  }
}

extension ReplyValueCopy<$R, $Out> on ObjectCopyWith<$R, Reply, $Out> {
  ReplyCopyWith<$R, Reply, $Out> get $asReply =>
      $base.as((v, t, t2) => _ReplyCopyWithImpl(v, t, t2));
}

abstract class ReplyCopyWith<$R, $In extends Reply, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MemberCopyWith<$R, Member, Member> get member;
  ScheduleCopyWith<$R, Schedule, Schedule> get schedule;
  $R call(
      {Member? member,
      Schedule? schedule,
      DateTime? instanceDate,
      ReplyOptions? selectedOption,
      DateTime? createdAt,
      DateTime? updatedAt});
  ReplyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReplyCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Reply, $Out>
    implements ReplyCopyWith<$R, Reply, $Out> {
  _ReplyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Reply> $mapper = ReplyMapper.ensureInitialized();
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
          DateTime? instanceDate,
          ReplyOptions? selectedOption,
          Object? createdAt = $none,
          Object? updatedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (member != null) #member: member,
        if (schedule != null) #schedule: schedule,
        if (instanceDate != null) #instanceDate: instanceDate,
        if (selectedOption != null) #selectedOption: selectedOption,
        if (createdAt != $none) #createdAt: createdAt,
        if (updatedAt != $none) #updatedAt: updatedAt
      }));
  @override
  Reply $make(CopyWithData data) => Reply(
      member: data.get(#member, or: $value.member),
      schedule: data.get(#schedule, or: $value.schedule),
      instanceDate: data.get(#instanceDate, or: $value.instanceDate),
      selectedOption: data.get(#selectedOption, or: $value.selectedOption),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  ReplyCopyWith<$R2, Reply, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ReplyCopyWithImpl($value, $cast, t);
}
