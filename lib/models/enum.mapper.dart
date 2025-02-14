// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'enum.dart';

class InviteMethodsMapper extends EnumMapper<InviteMethods> {
  InviteMethodsMapper._();

  static InviteMethodsMapper? _instance;
  static InviteMethodsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InviteMethodsMapper._());
    }
    return _instance!;
  }

  static InviteMethods fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  InviteMethods decode(dynamic value) {
    switch (value) {
      case 'email':
        return InviteMethods.email;
      case 'phone':
        return InviteMethods.phone;
      case 'code':
        return InviteMethods.code;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(InviteMethods self) {
    switch (self) {
      case InviteMethods.email:
        return 'email';
      case InviteMethods.phone:
        return 'phone';
      case InviteMethods.code:
        return 'code';
    }
  }
}

extension InviteMethodsMapperExtension on InviteMethods {
  String toValue() {
    InviteMethodsMapper.ensureInitialized();
    return MapperContainer.globals.toValue<InviteMethods>(this) as String;
  }
}

class ReplyOptionsMapper extends EnumMapper<ReplyOptions> {
  ReplyOptionsMapper._();

  static ReplyOptionsMapper? _instance;
  static ReplyOptionsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReplyOptionsMapper._());
    }
    return _instance!;
  }

  static ReplyOptions fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReplyOptions decode(dynamic value) {
    switch (value) {
      case 'yes':
        return ReplyOptions.yes;
      case 'no':
        return ReplyOptions.no;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReplyOptions self) {
    switch (self) {
      case ReplyOptions.yes:
        return 'yes';
      case ReplyOptions.no:
        return 'no';
    }
  }
}

extension ReplyOptionsMapperExtension on ReplyOptions {
  String toValue() {
    ReplyOptionsMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReplyOptions>(this) as String;
  }
}

class GroupRolesMapper extends EnumMapper<GroupRoles> {
  GroupRolesMapper._();

  static GroupRolesMapper? _instance;
  static GroupRolesMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GroupRolesMapper._());
    }
    return _instance!;
  }

  static GroupRoles fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  GroupRoles decode(dynamic value) {
    switch (value) {
      case 'admin':
        return GroupRoles.admin;
      case 'member':
        return GroupRoles.member;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(GroupRoles self) {
    switch (self) {
      case GroupRoles.admin:
        return 'admin';
      case GroupRoles.member:
        return 'member';
    }
  }
}

extension GroupRolesMapperExtension on GroupRoles {
  String toValue() {
    GroupRolesMapper.ensureInitialized();
    return MapperContainer.globals.toValue<GroupRoles>(this) as String;
  }
}
