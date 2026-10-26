import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

import 'view_model.dart';

/// One member of a group: their role, pending invites, and removal.
class MemberDetailsViewModel extends ViewModel {
  MemberDetailsViewModel({
    required this.groupId,
    required this.memberId,
    required this._groups,
  }) {
    load = Command0(_load)..execute();
    setRole = Command1(
      (role) => _withMember((member) => _groups.setRole(member, role)),
    );
    remove = Command0(() => _withMember(_groups.remove));
    createInvite = Command0(() => _withMember(_groups.createInviteCode));
    cancelInvites = Command0(() => _withMember(_groups.cancelInvites));
    listenTo([_groups, load, setRole, remove, createInvite, cancelInvites]);
  }

  final String groupId;
  final String memberId;
  final GroupsRepository _groups;

  late final Command0<void> load;
  late final Command1<void, GroupRoles> setRole;
  late final Command0<void> remove;

  /// A code for a member who hasn't joined: it takes a seat.
  late final Command0<void> createInvite;

  /// Withdraws the pending invites: the member stays, answered for by admins.
  late final Command0<void> cancelInvites;

  Group? get group => _groups.group(groupId);

  Member? get member => _groups.member(memberId);

  Profile? get profile => _groups.profile(member?.profileId);

  /// The pending invites, once loaded. Only admins can see them.
  List<Invite>? get invites => _groups.invites(memberId);

  bool get isCurrentUser =>
      member?.profileId != null && member?.profileId == _groups.userId;

  /// Whether the user may change roles and remove members.
  bool get isAdmin => _groups.ownMember(groupId)?.role == GroupRoles.admin;

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _groups.loadInvites(memberId),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  Future<Result<void>> _withMember(
    Future<Result<void>> Function(Member member) action,
  ) async {
    final member = this.member;
    if (member == null) return const Result.error(NotFoundException());
    return action(member);
  }
}
