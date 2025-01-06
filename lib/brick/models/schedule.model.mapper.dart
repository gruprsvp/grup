// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'schedule.model.dart';

class ScheduleMapper extends ClassMapperBase<Schedule> {
  ScheduleMapper._();

  static ScheduleMapper? _instance;
  static ScheduleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduleMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Schedule';

  static Group _$group(Schedule v) => v.group;
  static const Field<Schedule, Group> _f$group = Field('group', _$group);
  static String _$displayName(Schedule v) => v.displayName;
  static const Field<Schedule, String> _f$displayName =
      Field('displayName', _$displayName);
  static DateTime _$startDate(Schedule v) => v.startDate;
  static const Field<Schedule, DateTime> _f$startDate =
      Field('startDate', _$startDate);
  static RecurrenceRule _$recurrenceRule(Schedule v) => v.recurrenceRule;
  static const Field<Schedule, RecurrenceRule> _f$recurrenceRule =
      Field('recurrenceRule', _$recurrenceRule);
  static DateTime? _$createdAt(Schedule v) => v.createdAt;
  static const Field<Schedule, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, opt: true);
  static DateTime? _$updatedAt(Schedule v) => v.updatedAt;
  static const Field<Schedule, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, opt: true);
  static String? _$id(Schedule v) => v.id;
  static const Field<Schedule, String> _f$id = Field('id', _$id, opt: true);

  @override
  final MappableFields<Schedule> fields = const {
    #group: _f$group,
    #displayName: _f$displayName,
    #startDate: _f$startDate,
    #recurrenceRule: _f$recurrenceRule,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #id: _f$id,
  };

  static Schedule _instantiate(DecodingData data) {
    return Schedule(
        group: data.dec(_f$group),
        displayName: data.dec(_f$displayName),
        startDate: data.dec(_f$startDate),
        recurrenceRule: data.dec(_f$recurrenceRule),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static Schedule fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Schedule>(map);
  }

  static Schedule fromJson(String json) {
    return ensureInitialized().decodeJson<Schedule>(json);
  }
}

mixin ScheduleMappable {
  String toJson() {
    return ScheduleMapper.ensureInitialized()
        .encodeJson<Schedule>(this as Schedule);
  }

  Map<String, dynamic> toMap() {
    return ScheduleMapper.ensureInitialized()
        .encodeMap<Schedule>(this as Schedule);
  }

  ScheduleCopyWith<Schedule, Schedule, Schedule> get copyWith =>
      _ScheduleCopyWithImpl(this as Schedule, $identity, $identity);
  @override
  String toString() {
    return ScheduleMapper.ensureInitialized().stringifyValue(this as Schedule);
  }

  @override
  bool operator ==(Object other) {
    return ScheduleMapper.ensureInitialized()
        .equalsValue(this as Schedule, other);
  }

  @override
  int get hashCode {
    return ScheduleMapper.ensureInitialized().hashValue(this as Schedule);
  }
}

extension ScheduleValueCopy<$R, $Out> on ObjectCopyWith<$R, Schedule, $Out> {
  ScheduleCopyWith<$R, Schedule, $Out> get $asSchedule =>
      $base.as((v, t, t2) => _ScheduleCopyWithImpl(v, t, t2));
}

abstract class ScheduleCopyWith<$R, $In extends Schedule, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {Group? group,
      String? displayName,
      DateTime? startDate,
      RecurrenceRule? recurrenceRule,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? id});
  ScheduleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScheduleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Schedule, $Out>
    implements ScheduleCopyWith<$R, Schedule, $Out> {
  _ScheduleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Schedule> $mapper =
      ScheduleMapper.ensureInitialized();
  @override
  $R call(
          {Group? group,
          String? displayName,
          DateTime? startDate,
          RecurrenceRule? recurrenceRule,
          Object? createdAt = $none,
          Object? updatedAt = $none,
          Object? id = $none}) =>
      $apply(FieldCopyWithData({
        if (group != null) #group: group,
        if (displayName != null) #displayName: displayName,
        if (startDate != null) #startDate: startDate,
        if (recurrenceRule != null) #recurrenceRule: recurrenceRule,
        if (createdAt != $none) #createdAt: createdAt,
        if (updatedAt != $none) #updatedAt: updatedAt,
        if (id != $none) #id: id
      }));
  @override
  Schedule $make(CopyWithData data) => Schedule(
      group: data.get(#group, or: $value.group),
      displayName: data.get(#displayName, or: $value.displayName),
      startDate: data.get(#startDate, or: $value.startDate),
      recurrenceRule: data.get(#recurrenceRule, or: $value.recurrenceRule),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      id: data.get(#id, or: $value.id));

  @override
  ScheduleCopyWith<$R2, Schedule, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ScheduleCopyWithImpl($value, $cast, t);
}
