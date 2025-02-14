import 'package:dart_mappable/dart_mappable.dart';

part 'enum.mapper.dart';

/// Defines the different methods of inviting a user to a group.
@MappableEnum()
enum InviteMethods { email, phone, code }

/// Reply options for the user to choose from
@MappableEnum()
enum ReplyOptions { yes, no }

/// The different roles a user can have in a group
@MappableEnum()
enum GroupRoles { admin, member }
