// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile.model.dart';

class ProfileMapper extends ClassMapperBase<Profile> {
  ProfileMapper._();

  static ProfileMapper? _instance;
  static ProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Profile';

  static String _$id(Profile v) => v.id;
  static const Field<Profile, String> _f$id = Field('id', _$id);
  static String? _$displayName(Profile v) => v.displayName;
  static const Field<Profile, String> _f$displayName =
      Field('displayName', _$displayName, opt: true);
  static String? _$picture(Profile v) => v.picture;
  static const Field<Profile, String> _f$picture =
      Field('picture', _$picture, opt: true);

  @override
  final MappableFields<Profile> fields = const {
    #id: _f$id,
    #displayName: _f$displayName,
    #picture: _f$picture,
  };

  static Profile _instantiate(DecodingData data) {
    return Profile(
        id: data.dec(_f$id),
        displayName: data.dec(_f$displayName),
        picture: data.dec(_f$picture));
  }

  @override
  final Function instantiate = _instantiate;

  static Profile fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Profile>(map);
  }

  static Profile fromJsonString(String json) {
    return ensureInitialized().decodeJson<Profile>(json);
  }
}

mixin ProfileMappable {
  String toJsonString() {
    return ProfileMapper.ensureInitialized()
        .encodeJson<Profile>(this as Profile);
  }

  Map<String, dynamic> toJson() {
    return ProfileMapper.ensureInitialized()
        .encodeMap<Profile>(this as Profile);
  }

  ProfileCopyWith<Profile, Profile, Profile> get copyWith =>
      _ProfileCopyWithImpl(this as Profile, $identity, $identity);
  @override
  String toString() {
    return ProfileMapper.ensureInitialized().stringifyValue(this as Profile);
  }

  @override
  bool operator ==(Object other) {
    return ProfileMapper.ensureInitialized()
        .equalsValue(this as Profile, other);
  }

  @override
  int get hashCode {
    return ProfileMapper.ensureInitialized().hashValue(this as Profile);
  }
}

extension ProfileValueCopy<$R, $Out> on ObjectCopyWith<$R, Profile, $Out> {
  ProfileCopyWith<$R, Profile, $Out> get $asProfile =>
      $base.as((v, t, t2) => _ProfileCopyWithImpl(v, t, t2));
}

abstract class ProfileCopyWith<$R, $In extends Profile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? displayName, String? picture});
  ProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Profile, $Out>
    implements ProfileCopyWith<$R, Profile, $Out> {
  _ProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Profile> $mapper =
      ProfileMapper.ensureInitialized();
  @override
  $R call({String? id, Object? displayName = $none, Object? picture = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (displayName != $none) #displayName: displayName,
        if (picture != $none) #picture: picture
      }));
  @override
  Profile $make(CopyWithData data) => Profile(
      id: data.get(#id, or: $value.id),
      displayName: data.get(#displayName, or: $value.displayName),
      picture: data.get(#picture, or: $value.picture));

  @override
  ProfileCopyWith<$R2, Profile, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProfileCopyWithImpl($value, $cast, t);
}
