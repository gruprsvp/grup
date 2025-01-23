// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'group.model.dart';

class GroupMapper extends ClassMapperBase<Group> {
  GroupMapper._();

  static GroupMapper? _instance;
  static GroupMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Group';

  static String _$displayName(Group v) => v.displayName;
  static const Field<Group, String> _f$displayName =
      Field('displayName', _$displayName);
  static String? _$description(Group v) => v.description;
  static const Field<Group, String> _f$description =
      Field('description', _$description, opt: true);
  static String? _$picture(Group v) => v.picture;
  static const Field<Group, String> _f$picture =
      Field('picture', _$picture, opt: true);
  static String _$id(Group v) => v.id;
  static const Field<Group, String> _f$id = Field('id', _$id, opt: true);

  @override
  final MappableFields<Group> fields = const {
    #displayName: _f$displayName,
    #description: _f$description,
    #picture: _f$picture,
    #id: _f$id,
  };

  static Group _instantiate(DecodingData data) {
    return Group(
        displayName: data.dec(_f$displayName),
        description: data.dec(_f$description),
        picture: data.dec(_f$picture),
        id: data.dec(_f$id));
  }

  @override
  final Function instantiate = _instantiate;

  static Group fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Group>(map);
  }

  static Group fromJsonString(String json) {
    return ensureInitialized().decodeJson<Group>(json);
  }
}

mixin GroupMappable {
  String toJsonString() {
    return GroupMapper.ensureInitialized().encodeJson<Group>(this as Group);
  }

  Map<String, dynamic> toJson() {
    return GroupMapper.ensureInitialized().encodeMap<Group>(this as Group);
  }

  GroupCopyWith<Group, Group, Group> get copyWith =>
      _GroupCopyWithImpl(this as Group, $identity, $identity);
  @override
  String toString() {
    return GroupMapper.ensureInitialized().stringifyValue(this as Group);
  }

  @override
  bool operator ==(Object other) {
    return GroupMapper.ensureInitialized().equalsValue(this as Group, other);
  }

  @override
  int get hashCode {
    return GroupMapper.ensureInitialized().hashValue(this as Group);
  }
}

extension GroupValueCopy<$R, $Out> on ObjectCopyWith<$R, Group, $Out> {
  GroupCopyWith<$R, Group, $Out> get $asGroup =>
      $base.as((v, t, t2) => _GroupCopyWithImpl(v, t, t2));
}

abstract class GroupCopyWith<$R, $In extends Group, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? displayName, String? description, String? picture, String? id});
  GroupCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GroupCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Group, $Out>
    implements GroupCopyWith<$R, Group, $Out> {
  _GroupCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Group> $mapper = GroupMapper.ensureInitialized();
  @override
  $R call(
          {String? displayName,
          Object? description = $none,
          Object? picture = $none,
          Object? id = $none}) =>
      $apply(FieldCopyWithData({
        if (displayName != null) #displayName: displayName,
        if (description != $none) #description: description,
        if (picture != $none) #picture: picture,
        if (id != $none) #id: id
      }));
  @override
  Group $make(CopyWithData data) => Group(
      displayName: data.get(#displayName, or: $value.displayName),
      description: data.get(#description, or: $value.description),
      picture: data.get(#picture, or: $value.picture),
      id: data.get(#id, or: $value.id));

  @override
  GroupCopyWith<$R2, Group, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GroupCopyWithImpl($value, $cast, t);
}
