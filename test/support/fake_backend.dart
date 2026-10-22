import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/util.dart';
import 'package:rrule/rrule.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// An in-memory stand-in for Supabase, behind fakes of the app's services.
///
/// Rows are visible to [userId] roughly as row-level security would allow:
/// group data only to the group's members.
class FakeBackend {
  FakeBackend({this.userId = 'me'});

  /// The signed-in user, or `null`. Change it through [auth].
  String? userId;

  final groups = <String, Group>{};
  final members = <String, Member>{};
  final profiles = <String, Profile>{};
  final invites = <String, Invite>{};
  final schedules = <String, Schedule>{};
  final defaultRules = <(String, String), DefaultRule>{};
  final replies = <(String, String, DateTime), Reply>{};

  /// While set, every service call throws it.
  Object? failure;

  /// While set, service calls wait for it to complete.
  Completer<void>? gate;

  var _ids = 0;
  String nextId(String prefix) => '$prefix-${++_ids}';

  late final auth = FakeAuth(this);
  late final groupsService = _FakeGroupsService(this);
  late final membersService = _FakeMembersService(this);
  late final invitesService = _FakeInvitesService(this);
  late final profilesService = _FakeProfilesService(this);
  late final storageService = _FakeStorageService(this);
  late final schedulesService = _FakeSchedulesService(this);
  late final defaultRulesService = _FakeDefaultRulesService(this);
  late final repliesService = _FakeRepliesService(this);

  /// The fakes, for Repositories.create.
  Services get services => (
    auth: auth,
    groups: groupsService,
    members: membersService,
    invites: invitesService,
    profiles: profilesService,
    storage: storageService,
    schedules: schedulesService,
    defaultRules: defaultRulesService,
    replies: repliesService,
  );

  // -- Seeding ---------------------------------------------------------------

  Profile addProfile(String id, {String? name, DateTime? createdAt}) =>
      profiles[id] = Profile(id: id, displayName: name, createdAt: createdAt);

  /// A group whose admin is the signed-in user.
  Group addGroup(String name, {String? id}) {
    final group = Group(id: id ?? nextId('group'), displayName: name);
    groups[group.id] = group;
    profiles.putIfAbsent(
      userId!,
      () => Profile(id: userId!, displayName: 'Me'),
    );
    addMember(group.id, profileId: userId, role: GroupRoles.admin);
    return group;
  }

  Member addMember(
    String groupId, {
    String? profileId,
    String? name,
    GroupRoles role = GroupRoles.member,
  }) {
    final member = Member(
      id: nextId('member'),
      groupId: groupId,
      profileId: profileId,
      displayNameOverride: name,
      role: role,
    );
    return members[member.id] = member;
  }

  Schedule addSchedule(
    String groupId, {
    String name = 'Dinner',
    DateTime? start,
    RecurrenceRule? rule,
  }) {
    final schedule = Schedule(
      id: nextId('schedule'),
      groupId: groupId,
      displayName: name,
      startDate: start ?? DateTime.utc(2024, 1, 1, 18),
      recurrenceRule: rule ?? CommonRecurrenceRules.daily,
    );
    return schedules[schedule.id] = schedule;
  }

  Reply addReply(Reply reply) => replies[_replyKey(reply)] = reply;

  // -- Row-level security, roughly -------------------------------------------

  bool _isMember(String groupId, {bool admin = false}) => members.values.any(
    (m) =>
        m.groupId == groupId &&
        m.profileId == userId &&
        (!admin || m.role == GroupRoles.admin),
  );

  Iterable<Group> get _visibleGroups =>
      groups.values.where((group) => _isMember(group.id));

  GroupsAndMembers _withMembers(Iterable<Group> groups) {
    final ids = {for (final group in groups) group.id};
    final groupMembers = members.values.where((m) => ids.contains(m.groupId));
    return (
      groups: groups.toList(),
      members: groupMembers.toList(),
      profiles: {
        for (final profile in groupMembers.map((m) => profiles[m.profileId]))
          ?profile?.id: ?profile,
      }.values,
    );
  }

  Future<void> _call() async {
    await gate?.future;
    if (failure case final failure?) throw failure;
  }

  static const notFound = PostgrestException(
    message: 'JSON object requested, multiple (or no) rows returned',
    code: 'PGRST116',
  );

  static (String, String, DateTime) _replyKey(Reply r) =>
      (r.memberId, r.scheduleId, r.instanceDate.toUtc());
}

/// Stands in for Supabase's GoTrueClient.
class FakeAuth extends Fake implements GoTrueClient {
  FakeAuth(this._backend);

  final FakeBackend _backend;
  final _changes = StreamController<AuthState>.broadcast();

  @override
  User? get currentUser => switch (_backend.userId) {
    final id? => User(
      id: id,
      appMetadata: const {},
      userMetadata: const {},
      aud: 'authenticated',
      createdAt: '2024-01-01T00:00:00Z',
    ),
    null => null,
  };

  @override
  Stream<AuthState> get onAuthStateChange => _changes.stream;

  /// Signs [userId] in, or out when null, and emits the auth event.
  void signIn(String? userId) {
    _backend.userId = userId;
    emit(userId == null ? AuthChangeEvent.signedOut : AuthChangeEvent.signedIn);
  }

  void emit(AuthChangeEvent event) => _changes.add(
    AuthState(event, switch (currentUser) {
      final user? => Session(
        accessToken: 'token',
        tokenType: 'bearer',
        user: user,
      ),
      null => null,
    }),
  );

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async {
    await _backend._call();
    signIn(null);
  }
}

class _FakeGroupsService extends Fake implements GroupsService {
  _FakeGroupsService(this._b);
  final FakeBackend _b;

  @override
  Future<GroupsAndMembers> getUserGroups() async {
    await _b._call();
    return _b._withMembers(_b._visibleGroups);
  }

  @override
  Future<GroupsAndMembers> getGroupById(String id) async {
    await _b._call();
    final group = _b._visibleGroups.where((g) => g.id == id).toList();
    if (group.isEmpty) throw FakeBackend.notFound;
    return _b._withMembers(group);
  }

  @override
  Future<Group> createGroup(Group group) async {
    await _b._call();
    final created = group.copyWith(id: _b.nextId('group'));
    _b.groups[created.id] = created;
    _b.addMember(created.id, profileId: _b.userId, role: GroupRoles.admin);
    return created;
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await _b._call();
    if (!_b._isMember(group.id, admin: true)) throw FakeBackend.notFound;
    return _b.groups[group.id] = group;
  }

  @override
  Future<Group> deleteGroup(String id) async {
    await _b._call();
    if (!_b._isMember(id, admin: true)) throw FakeBackend.notFound;
    _b.members.removeWhere((_, m) => m.groupId == id);
    return _b.groups.remove(id)!;
  }
}

class _FakeMembersService extends Fake implements MembersService {
  _FakeMembersService(this._b);
  final FakeBackend _b;

  @override
  Future<Member> addMemberToGroup(
    String groupId, {
    String? displayName,
    String? profileId,
  }) async {
    await _b._call();
    return _b.addMember(groupId, profileId: profileId, name: displayName);
  }

  @override
  Future<Member> updateMember({
    required String memberId,
    String? displayNameOverride,
    GroupRoles? role,
  }) async {
    await _b._call();
    final member = _b.members[memberId] ?? (throw FakeBackend.notFound);
    return _b.members[memberId] = member.copyWith(
      displayNameOverride: displayNameOverride ?? member.displayNameOverride,
      role: role ?? member.role,
    );
  }

  @override
  Future<void> deleteMember(String memberId) async {
    await _b._call();
    _b.members.remove(memberId) ?? (throw FakeBackend.notFound);
  }
}

class _FakeInvitesService extends Fake implements InvitesService {
  _FakeInvitesService(this._b);
  final FakeBackend _b;

  @override
  Future<Invite> inviteMember(
    String memberId,
    InviteMethods method,
    String value,
  ) async {
    await _b._call();
    final invite = Invite(
      id: _b.nextId('invite'),
      memberId: memberId,
      method: method,
      value: value,
    );
    return _b.invites[invite.id] = invite;
  }

  @override
  Future<Invite> inviteWithGeneratedCode(String memberId) =>
      inviteMember(memberId, InviteMethods.code, 'CODE-${_b.nextId('')}');

  @override
  Future<void> consumeInviteCode(String code) async {
    await _b._call();
    final invite = _b.invites.values.firstWhere(
      (i) => i.method == InviteMethods.code && i.value == code,
      orElse: () => throw const InvalidInviteCodeException(),
    );
    final member = _b.members[invite.memberId]!;
    if (_b._isMember(member.groupId)) throw const AlreadyMemberException();
    _b.members[member.id] = member.copyWith(profileId: _b.userId);
    _b.invites.removeWhere((_, i) => i.memberId == member.id);
  }

  @override
  Future<List<Invite>> getInvitesForMember(String memberId) async {
    await _b._call();
    return _b.invites.values.where((i) => i.memberId == memberId).toList();
  }
}

class _FakeProfilesService extends Fake implements ProfilesService {
  _FakeProfilesService(this._b);
  final FakeBackend _b;

  @override
  Future<Profile> getProfileById(String id) async {
    await _b._call();
    return _b.profiles[id] ?? (throw FakeBackend.notFound);
  }

  @override
  Future<UserResponse> updateProfile({
    required String id,
    String? displayName,
    String? pictureUrl,
  }) async {
    await _b._call();
    final profile = _b.profiles[id] ?? Profile(id: id);
    _b.profiles[id] = profile.copyWith(
      displayName: displayName ?? profile.displayName,
      picture: pictureUrl ?? profile.picture,
    );
    return UserResponse.fromJson({'id': id});
  }

  @override
  Future<void> deleteProfile() async {
    await _b._call();
    _b.profiles.remove(_b.userId);
  }

  @override
  Future<void> signOut() => _b.auth.signOut();
}

class _FakeStorageService extends Fake implements StorageService {
  _FakeStorageService(this._b);
  final FakeBackend _b;

  @override
  Future<String> uploadPublicXFile(String key, XFile file) async {
    await _b._call();
    return 'https://storage.test/${_b.userId}/$key';
  }

  @override
  Future<void> deleteUserFiles() => _b._call();
}

class _FakeSchedulesService extends Fake implements SchedulesService {
  _FakeSchedulesService(this._b);
  final FakeBackend _b;

  @override
  Future<List<Schedule>> getGroupSchedules(String groupId) async {
    await _b._call();
    if (!_b._isMember(groupId)) return [];
    return _b.schedules.values.where((s) => s.groupId == groupId).toList();
  }

  @override
  Future<Schedule> createSchedule(Schedule schedule) async {
    await _b._call();
    final created = schedule.copyWith(id: _b.nextId('schedule'));
    return _b.schedules[created.id] = created;
  }

  @override
  Future<void> deleteSchedule(String scheduleId) async {
    await _b._call();
    _b.schedules.remove(scheduleId) ?? (throw FakeBackend.notFound);
    _b.replies.removeWhere((_, r) => r.scheduleId == scheduleId);
    _b.defaultRules.removeWhere((_, r) => r.scheduleId == scheduleId);
  }
}

class _FakeDefaultRulesService extends Fake implements DefaultRulesService {
  _FakeDefaultRulesService(this._b);
  final FakeBackend _b;

  @override
  Future<List<DefaultRule>> getDefaultRules(String groupId) async {
    await _b._call();
    return _b.defaultRules.values
        .where((r) => _b.schedules[r.scheduleId]?.groupId == groupId)
        .toList();
  }

  @override
  Future<DefaultRule> createDefaultRule(DefaultRule rule) async {
    await _b._call();
    return _b.defaultRules[(rule.memberId, rule.scheduleId)] = rule;
  }

  @override
  Future<void> deleteDefaultRule({
    required String memberId,
    required String scheduleId,
  }) async {
    await _b._call();
    _b.defaultRules.remove((memberId, scheduleId)) ??
        (throw FakeBackend.notFound);
  }
}

class _FakeRepliesService extends Fake implements RepliesService {
  _FakeRepliesService(this._b);
  final FakeBackend _b;

  @override
  Future<List<Reply>> getRepliesForDateRange(
    String groupId,
    DateTimeRange dateRange,
  ) async {
    await _b._call();
    return _b.replies.values
        .where(
          (r) =>
              _b.schedules[r.scheduleId]?.groupId == groupId &&
              !r.instanceDate.isBefore(dateRange.start) &&
              r.instanceDate.isBefore(dateRange.end),
        )
        .toList();
  }

  @override
  Future<Reply> createReply(Reply reply) async {
    await _b._call();
    return _b.addReply(reply);
  }

  @override
  Future<void> deleteReply({
    required String memberId,
    required String scheduleId,
    required DateTime instanceDate,
  }) async {
    await _b._call();
    _b.replies.remove((memberId, scheduleId, instanceDate.toUtc())) ??
        (throw FakeBackend.notFound);
  }
}
