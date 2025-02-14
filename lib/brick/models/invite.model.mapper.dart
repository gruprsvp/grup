// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'invite.model.dart';

class InviteMapper extends ClassMapperBase<Invite> {
  InviteMapper._();

  static InviteMapper? _instance;
  static InviteMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InviteMapper._());
      MemberMapper.ensureInitialized();
      InviteMethodsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Invite';

  static Member _$member(Invite v) => v.member;
  static const Field<Invite, Member> _f$member = Field('member', _$member);
  static InviteMethods _$method(Invite v) => v.method;
  static const Field<Invite, InviteMethods> _f$method =
      Field('method', _$method);
  static String _$value(Invite v) => v.value;
  static const Field<Invite, String> _f$value = Field('value', _$value);
  static String _$id(Invite v) => v.id;
  static const Field<Invite, String> _f$id = Field('id', _$id, opt: true);

  @override
  final MappableFields<Invite> fields = const {
    #member: _f$member,
    #method: _f$method,
    #value: _f$value,
    #id: _f$id,
  };

  static Invite _instantiate(DecodingData data) {
    return Invite(
        member: data.dec(_f$member),
        method: data.dec(_f$method),
        value: data.dec(_f$value),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static Invite fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Invite>(map);
  }

  static Invite fromJsonString(String json) {
    return ensureInitialized().decodeJson<Invite>(json);
  }
}

mixin InviteMappable {
  String toJsonString() {
    return InviteMapper.ensureInitialized().encodeJson<Invite>(this as Invite);
  }

  Map<String, dynamic> toJson() {
    return InviteMapper.ensureInitialized().encodeMap<Invite>(this as Invite);
  }

  InviteCopyWith<Invite, Invite, Invite> get copyWith =>
      _InviteCopyWithImpl(this as Invite, $identity, $identity);
  @override
  String toString() {
    return InviteMapper.ensureInitialized().stringifyValue(this as Invite);
  }

  @override
  bool operator ==(Object other) {
    return InviteMapper.ensureInitialized().equalsValue(this as Invite, other);
  }

  @override
  int get hashCode {
    return InviteMapper.ensureInitialized().hashValue(this as Invite);
  }
}

extension InviteValueCopy<$R, $Out> on ObjectCopyWith<$R, Invite, $Out> {
  InviteCopyWith<$R, Invite, $Out> get $asInvite =>
      $base.as((v, t, t2) => _InviteCopyWithImpl(v, t, t2));
}

abstract class InviteCopyWith<$R, $In extends Invite, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MemberCopyWith<$R, Member, Member> get member;
  $R call({Member? member, InviteMethods? method, String? value, String? id});
  InviteCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InviteCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Invite, $Out>
    implements InviteCopyWith<$R, Invite, $Out> {
  _InviteCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Invite> $mapper = InviteMapper.ensureInitialized();
  @override
  MemberCopyWith<$R, Member, Member> get member =>
      $value.member.copyWith.$chain((v) => call(member: v));
  @override
  $R call(
          {Member? member,
          InviteMethods? method,
          String? value,
          Object? id = $none}) =>
      $apply(FieldCopyWithData({
        if (member != null) #member: member,
        if (method != null) #method: method,
        if (value != null) #value: value,
        if (id != $none) #id: id
      }));
  @override
  Invite $make(CopyWithData data) => Invite(
      member: data.get(#member, or: $value.member),
      method: data.get(#method, or: $value.method),
      value: data.get(#value, or: $value.value),
      id: data.get(#id, or: $value.id));

  @override
  InviteCopyWith<$R2, Invite, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InviteCopyWithImpl($value, $cast, t);
}
