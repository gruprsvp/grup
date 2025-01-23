// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'member.model.dart';

class MemberMapper extends ClassMapperBase<Member> {
  MemberMapper._();

  static MemberMapper? _instance;
  static MemberMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MemberMapper._());
      GroupMapper.ensureInitialized();
      ProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Member';

  static Group _$group(Member v) => v.group;
  static const Field<Member, Group> _f$group = Field('group', _$group);
  static GroupRoles _$role(Member v) => v.role;
  static const Field<Member, GroupRoles> _f$role = Field('role', _$role);
  static Profile? _$profile(Member v) => v.profile;
  static const Field<Member, Profile> _f$profile =
      Field('profile', _$profile, opt: true);
  static String? _$displayNameOverride(Member v) => v.displayNameOverride;
  static const Field<Member, String> _f$displayNameOverride =
      Field('displayNameOverride', _$displayNameOverride, opt: true);
  static String _$id(Member v) => v.id;
  static const Field<Member, String> _f$id = Field('id', _$id, opt: true);

  @override
  final MappableFields<Member> fields = const {
    #group: _f$group,
    #role: _f$role,
    #profile: _f$profile,
    #displayNameOverride: _f$displayNameOverride,
    #id: _f$id,
  };

  static Member _instantiate(DecodingData data) {
    return Member(
        group: data.dec(_f$group),
        role: data.dec(_f$role),
        profile: data.dec(_f$profile),
        displayNameOverride: data.dec(_f$displayNameOverride),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static Member fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Member>(map);
  }

  static Member fromJsonString(String json) {
    return ensureInitialized().decodeJson<Member>(json);
  }
}

mixin MemberMappable {
  String toJsonString() {
    return MemberMapper.ensureInitialized().encodeJson<Member>(this as Member);
  }

  Map<String, dynamic> toJson() {
    return MemberMapper.ensureInitialized().encodeMap<Member>(this as Member);
  }

  MemberCopyWith<Member, Member, Member> get copyWith =>
      _MemberCopyWithImpl(this as Member, $identity, $identity);
  @override
  String toString() {
    return MemberMapper.ensureInitialized().stringifyValue(this as Member);
  }

  @override
  bool operator ==(Object other) {
    return MemberMapper.ensureInitialized().equalsValue(this as Member, other);
  }

  @override
  int get hashCode {
    return MemberMapper.ensureInitialized().hashValue(this as Member);
  }
}

extension MemberValueCopy<$R, $Out> on ObjectCopyWith<$R, Member, $Out> {
  MemberCopyWith<$R, Member, $Out> get $asMember =>
      $base.as((v, t, t2) => _MemberCopyWithImpl(v, t, t2));
}

abstract class MemberCopyWith<$R, $In extends Member, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  GroupCopyWith<$R, Group, Group> get group;
  ProfileCopyWith<$R, Profile, Profile>? get profile;
  $R call(
      {Group? group,
      GroupRoles? role,
      Profile? profile,
      String? displayNameOverride,
      String? id});
  MemberCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MemberCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Member, $Out>
    implements MemberCopyWith<$R, Member, $Out> {
  _MemberCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Member> $mapper = MemberMapper.ensureInitialized();
  @override
  GroupCopyWith<$R, Group, Group> get group =>
      $value.group.copyWith.$chain((v) => call(group: v));
  @override
  ProfileCopyWith<$R, Profile, Profile>? get profile =>
      $value.profile?.copyWith.$chain((v) => call(profile: v));
  @override
  $R call(
          {Group? group,
          GroupRoles? role,
          Object? profile = $none,
          Object? displayNameOverride = $none,
          Object? id = $none}) =>
      $apply(FieldCopyWithData({
        if (group != null) #group: group,
        if (role != null) #role: role,
        if (profile != $none) #profile: profile,
        if (displayNameOverride != $none)
          #displayNameOverride: displayNameOverride,
        if (id != $none) #id: id
      }));
  @override
  Member $make(CopyWithData data) => Member(
      group: data.get(#group, or: $value.group),
      role: data.get(#role, or: $value.role),
      profile: data.get(#profile, or: $value.profile),
      displayNameOverride:
          data.get(#displayNameOverride, or: $value.displayNameOverride),
      id: data.get(#id, or: $value.id));

  @override
  MemberCopyWith<$R2, Member, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MemberCopyWithImpl($value, $cast, t);
}
