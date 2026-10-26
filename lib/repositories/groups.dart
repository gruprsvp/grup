import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/services/services.dart';
import 'package:parousia/util/analytics.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'user_data.dart';

/// The signed-in user's groups, their members, and those members' profiles.
class GroupsRepository extends UserData {
  GroupsRepository({
    required GroupsService groups,
    required MembersService members,
    required InvitesService invites,
    required this._storage,
    required LocalCache cache,
  }) : _groupsService = groups,
       _membersService = members,
       _invitesService = invites,
       super(cache, cacheKey);

  /// Where the device copy lives in [LocalCache].
  static const cacheKey = 'groups';

  final GroupsService _groupsService;
  final MembersService _membersService;
  final InvitesService _invitesService;
  final StorageService _storage;

  Map<String, Group> _groups = {};
  Map<String, Member> _members = {};
  Map<String, Profile> _profiles = {};
  // Invitees' email addresses and phone numbers: kept in memory only.
  Map<String, List<Invite>> _invites = {};

  /// The user's groups, by name.
  List<Group> get groups =>
      _groups.values.sortedBy((group) => group.displayName.toLowerCase());

  Group? group(String id) => _groups[id];

  /// The members of [groupId], newest first.
  List<Member> members(String groupId) => _members.values
      .where((member) => member.groupId == groupId)
      .sorted((a, b) => b.id.compareTo(a.id));

  Member? member(String id) => _members[id];

  /// The user's own membership of [groupId].
  Member? ownMember(String groupId) => _members.values.firstWhereOrNull(
    (member) => member.groupId == groupId && member.profileId == userId,
  );

  Profile? profile(String? id) => _profiles[id];

  /// The pending invites of [memberId], once [loadInvites] fetched them.
  List<Invite>? invites(String memberId) => _invites[memberId];

  /// Reloads all of the user's groups, replacing what is cached.
  Future<Result<void>> refresh() {
    final generation = this.generation;
    return guard(() async {
      final result = await _groupsService.getUserGroups();
      ifCurrent(generation, () {
        _groups = {for (final group in result.groups) group.id: group};
        _members = {for (final member in result.members) member.id: member};
        _profiles = {
          for (final profile in result.profiles) profile.id: profile,
        };
      });
    });
  }

  /// Reloads one group with its members.
  Future<Result<Group>> refreshGroup(String groupId) {
    final generation = this.generation;
    return guard(() => _loadGroup(groupId, generation));
  }

  Future<Group> _loadGroup(String groupId, int generation) async {
    final GroupsAndMembers result;
    try {
      result = await _groupsService.getGroupById(groupId);
    } on PostgrestException catch (e) {
      // Deleted, or the user is no longer a member: stop showing it.
      if (e.code == 'PGRST116') ifCurrent(generation, () => _forget(groupId));
      rethrow;
    }
    ifCurrent(generation, () {
      _groups = {
        ..._groups,
        for (final group in result.groups) group.id: group,
      };
      _members = {
        for (final member in _members.values)
          if (member.groupId != groupId) member.id: member,
        for (final member in result.members) member.id: member,
      };
      _profiles = {
        ..._profiles,
        for (final profile in result.profiles) profile.id: profile,
      };
    });
    return result.groups.single;
  }

  /// Creates a group with the user as its admin.
  Future<Result<Group>> create(Group group, {XFile? image}) {
    final generation = this.generation;
    return guard(() async {
      final picture = await _upload(image);
      final created = await _groupsService.createGroup(
        group.copyWith(picture: picture),
      );
      ifCurrent(generation, () => _groups = {..._groups, created.id: created});
      track('group created', {
        'group_id': created.id,
        'has_picture': picture != null,
      });
      // Also fetch the membership create_group added: the user, as admin.
      // The group exists either way, so this can't fail the creation.
      await guard(() => _loadGroup(created.id, generation));
      return created;
    });
  }

  /// Saves [group]'s details, with [image] as its new picture if set.
  Future<Result<Group>> update(Group group, {XFile? image}) {
    final generation = this.generation;
    return guard(() async {
      final picture = await _upload(image) ?? group.picture;
      final updated = await _groupsService.updateGroup(
        group.copyWith(picture: picture),
      );
      ifCurrent(generation, () => _groups = {..._groups, updated.id: updated});
      if (picture != group.picture) await _forgetFile(group.picture);
      return updated;
    });
  }

  /// Deletes [groupId], and with it its members, schedules and replies.
  Future<Result<void>> delete(String groupId) {
    final generation = this.generation;
    return guard(() async {
      final picture = _groups[groupId]?.picture;
      await _groupsService.deleteGroup(groupId);
      ifCurrent(generation, () => _forget(groupId));
      await _forgetFile(picture);
    });
  }

  /// Joins the group an invite [code] is for.
  Future<Result<void>> join(String code) => guard(() async {
    await _invitesService.consumeInviteCode(code);
    track('group joined');
    // The code doesn't say which group it was for: reload them all. Joining
    // already worked, so a failed reload only delays showing the group.
    await refresh();
  });

  /// Adds [contacts] to [groupId], each with an invite code plus an invite
  /// for every email address and phone number they have.
  Future<Result<void>> invite(String groupId, List<ContactInvite> contacts) {
    final generation = this.generation;
    return guard(() async {
      final results = await Future.wait([
        for (final contact in contacts) guard(() => _invite(groupId, contact)),
      ]);
      final invited = results.whereType<Ok<void>>().length;
      if (invited > 0) {
        track('members invited', {'group_id': groupId, 'count': invited});
      }
      // Invites for people who already have an account link them right away
      // (the handle_new_invite trigger), so reload to show who joined.
      await guard(() => _loadGroup(groupId, generation));
      for (final result in results) {
        if (result case Error(:final error)) throw error;
      }
    });
  }

  Future<void> _invite(String groupId, ContactInvite contact) async {
    final member = await _membersService.addMemberToGroup(
      groupId,
      displayName: contact.displayNameOverride,
    );
    // Just a name: a member the admins answer for. Without an invite they
    // take no seat; an admin can create a code for them later.
    if (contact.invites.isEmpty) return;
    try {
      await Future.wait([
        _invitesService.inviteWithGeneratedCode(member.id),
        for (final (method, value) in contact.invites)
          _invitesService.inviteMember(member.id, method, value),
      ]);
    } on PostgrestException catch (e) {
      // The group is full: the member created to hold the invite would stay
      // behind as one the admins manage. Best effort, the error is the news.
      if (e.message == 'group_full') {
        try {
          await _membersService.deleteMember(member.id);
        } on Object catch (_) {}
      }
      rethrow;
    }
  }

  /// Fetches [memberId]'s pending invites.
  Future<Result<void>> loadInvites(String memberId) {
    final generation = this.generation;
    return guard(() async {
      final invites = await _invitesService.getInvitesForMember(memberId);
      ifCurrent(generation, () => _invites = {..._invites, memberId: invites});
    });
  }

  /// Creates an invite code for [member], to join with. A pending invite
  /// takes a seat, so this fails in a full group.
  Future<Result<void>> createInviteCode(Member member) {
    final generation = this.generation;
    return guard(() async {
      final invite = await _invitesService.inviteWithGeneratedCode(member.id);
      ifCurrent(
        generation,
        () => _invites = {
          ..._invites,
          member.id: [...?_invites[member.id], invite],
        },
      );
    });
  }

  /// Withdraws [member]'s pending invites: they stay a member the admins
  /// answer for, and free their seat.
  Future<Result<void>> cancelInvites(Member member) {
    final generation = this.generation;
    return guard(() async {
      await _invitesService.deleteInvitesForMember(member.id);
      ifCurrent(generation, () => _invites = {..._invites, member.id: []});
    });
  }

  Future<Result<void>> setRole(Member member, GroupRoles role) {
    final generation = this.generation;
    return guard(() async {
      final updated = await _membersService.updateMember(
        memberId: member.id,
        role: role,
      );
      ifCurrent(
        generation,
        () => _members = {..._members, updated.id: updated},
      );
    });
  }

  /// Removes [member] from their group. When that is the user leaving, the
  /// whole group goes from the cache: they can no longer see it.
  Future<Result<void>> remove(Member member) {
    final generation = this.generation;
    return guard(() async {
      await _membersService.deleteMember(member.id);
      ifCurrent(generation, () {
        if (member.profileId != null && member.profileId == userId) {
          _forget(member.groupId);
        } else {
          _members = {..._members}..remove(member.id);
        }
      });
    });
  }

  /// Updates the cached copy of a profile the user just edited.
  void updateProfile(Profile profile) {
    if (!_profiles.containsKey(profile.id)) return;
    ifCurrent(
      generation,
      () => _profiles = {..._profiles, profile.id: profile},
    );
  }

  Future<String?> _upload(XFile? image) async => image == null
      ? null
      : await _storage.uploadPublicXFile(const Uuid().v7(), image);

  /// Deletes a picture no group shows any more. Best effort: a file left
  /// behind only takes up space, so a failure doesn't fail the change.
  Future<void> _forgetFile(String? url) async {
    if (url == null) return;
    try {
      await _storage.deletePublicUrl(url);
    } on Object catch (_) {}
  }

  void _forget(String groupId) {
    _groups = {..._groups}..remove(groupId);
    _members = {
      for (final member in _members.values)
        if (member.groupId != groupId) member.id: member,
    };
  }

  @override
  void clear() {
    _groups = {};
    _members = {};
    _profiles = {};
    _invites = {};
  }

  @override
  Map<String, dynamic> toCache() => {
    'groups': [for (final group in _groups.values) group.toJson()],
    'members': [for (final member in _members.values) member.toJson()],
    'profiles': [for (final profile in _profiles.values) profile.toJson()],
  };

  @override
  void fromCache(Map<String, dynamic> json) {
    List<Map<String, dynamic>> rows(String key) =>
        (json[key] as List).cast<Map<String, dynamic>>();
    _groups = {
      for (final group in rows('groups').map(Group.fromJson)) group.id: group,
    };
    _members = {
      for (final member in rows('members').map(Member.fromJson))
        member.id: member,
    };
    _profiles = {
      for (final profile in rows('profiles').map(Profile.fromJson))
        profile.id: profile,
    };
  }
}
