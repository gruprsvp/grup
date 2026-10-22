import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';

import 'view_model.dart';

/// Joining a group from an invite link.
class JoinGroupViewModel extends ViewModel {
  JoinGroupViewModel({required this.code, required GroupsRepository groups}) {
    join = Command0(() => groups.join(code))..execute();
    listenTo([join]);
  }

  final String code;

  late final Command0<void> join;
}
