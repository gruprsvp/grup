import 'package:flutter/foundation.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

/// Joining a group from an invite link.
class JoinGroupViewModel extends ChangeNotifier {
  JoinGroupViewModel({required this.code, required GroupsRepository groups}) {
    join = Command0(() => groups.join(code))..execute();
  }

  final String code;

  late final Command0<void> join;
}
