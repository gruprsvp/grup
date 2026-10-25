import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;
import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/groups.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

import '../support/fake_backend.dart';
import '../support/preferences.dart';

void main() {
  late FakeBackend backend;
  late LocalCache cache;
  late GroupsRepository repository;

  GroupsRepository newRepository() => GroupsRepository(
    groups: backend.groupsService,
    members: backend.membersService,
    invites: backend.invitesService,
    storage: backend.storageService,
    cache: cache,
  );

  setUp(() async {
    backend = FakeBackend();
    useInMemoryPreferences();
    cache = await openCache();
    repository = newRepository();
    repository.switchUser('me');
  });

  Exception? errorOf(Result<Object?> result) => switch (result) {
    Error(:final error) => error,
    Ok() => null,
  };

  test('refresh replaces what is cached, so deleted groups go away', () async {
    final kept = backend.addGroup('Kept');
    final deleted = backend.addGroup('Deleted');
    await repository.refresh();
    expect(repository.groups.map((g) => g.id), [deleted.id, kept.id]);

    backend.groups.remove(deleted.id);
    await repository.refresh();

    expect(repository.groups.map((g) => g.id), [kept.id]);
    expect(repository.members(deleted.id), isEmpty);
  });

  test('a failed refresh keeps the data and reports a network error', () async {
    backend.addGroup('Group');
    await repository.refresh();

    backend.failure = ClientException('offline');
    final result = await repository.refresh();

    expect(errorOf(result), isA<NetworkException>());
    expect(repository.groups, hasLength(1));
  });

  test('create adds the group with the user as admin', () async {
    final result = await repository.create(
      const Group(id: '', displayName: 'New'),
      image: XFile.fromData(Uint8List(0), mimeType: 'image/png'),
    );

    final group = (result as Ok<Group>).value;
    expect(repository.group(group.id)?.picture, startsWith('https://'));
    expect(repository.ownMember(group.id)?.role, GroupRoles.admin);
  });

  test('update without a new image keeps the picture', () async {
    final group = backend.addGroup('Group');
    backend.groups[group.id] = group.copyWith(picture: 'https://old.png');
    await repository.refresh();

    await repository.update(
      repository.group(group.id)!.copyWith(displayName: 'Renamed'),
    );

    expect(backend.groups[group.id]?.picture, 'https://old.png');
    expect(repository.group(group.id)?.displayName, 'Renamed');
  });

  test('a new image deletes the old picture, best effort', () async {
    final group = backend.addGroup('Group');
    backend.groups[group.id] = group.copyWith(picture: 'https://old.png');
    await repository.refresh();
    final image = XFile.fromData(Uint8List(0), mimeType: 'image/png');

    await repository.update(repository.group(group.id)!, image: image);
    expect(backend.storageService.deletedUrls, ['https://old.png']);

    backend.storageService.deleteFailure = ClientException('offline');
    final result = await repository.update(
      repository.group(group.id)!,
      image: image,
    );
    expect(result, isA<Ok<Group>>());
  });

  test('a failed update keeps the old picture', () async {
    final group = backend.addGroup('Group');
    backend.groups[group.id] = group.copyWith(picture: 'https://old.png');
    await repository.refresh();

    backend.failure = ClientException('offline');
    await repository.update(
      repository.group(group.id)!,
      image: XFile.fromData(Uint8List(0), mimeType: 'image/png'),
    );

    expect(backend.storageService.deletedUrls, isEmpty);
  });

  test('delete also deletes the picture', () async {
    final group = backend.addGroup('Group');
    backend.groups[group.id] = group.copyWith(picture: 'https://old.png');
    await repository.refresh();

    await repository.delete(group.id);

    expect(backend.storageService.deletedUrls, ['https://old.png']);
  });

  test('delete forgets the group; deleting it twice fails', () async {
    final group = backend.addGroup('Group');
    await repository.refresh();

    expect(await repository.delete(group.id), isA<Ok<void>>());
    expect(repository.group(group.id), isNull);
    expect(repository.members(group.id), isEmpty);

    expect(
      errorOf(await repository.delete(group.id)),
      isA<NotFoundException>(),
    );
  });

  test(
    'join reloads the groups; an unknown code fails with its own error',
    () async {
      final other = Group(id: 'other', displayName: 'Other');
      backend.groups[other.id] = other;
      final slot = backend.addMember(other.id, name: 'Invitee');
      final invite = await backend.invitesService.inviteWithGeneratedCode(
        slot.id,
      );

      expect(
        errorOf(await repository.join('NOPE-NOPE')),
        isA<InvalidInviteCodeException>(),
      );
      expect(await repository.join(invite.value), isA<Ok<void>>());
      expect(repository.group(other.id), isNotNull);
      expect(
        errorOf(await repository.join(invite.value)),
        isA<InvalidInviteCodeException>(), // a code works once
      );
    },
  );

  test(
    'invite adds a member per contact, with a code and their invites',
    () async {
      final group = backend.addGroup('Group');
      await repository.refresh();

      await repository.invite(group.id, const [
        ContactInvite(
          displayNameOverride: 'Ann',
          invites: [(InviteMethods.email, 'ann@example.com')],
        ),
        ContactInvite(displayNameOverride: 'Bob', invites: []),
      ]);

      final names = repository
          .members(group.id)
          .map((m) => m.displayNameOverride)
          .whereType<String>();
      expect(names, containsAll(['Ann', 'Bob']));
      final ann = repository
          .members(group.id)
          .firstWhere((m) => m.displayNameOverride == 'Ann');
      await repository.loadInvites(ann.id);
      expect(repository.invites(ann.id)?.map((i) => i.method), [
        InviteMethods.code,
        InviteMethods.email,
      ]);
    },
  );

  test('leaving a group forgets it; removing someone else keeps it', () async {
    final group = backend.addGroup('Group');
    final guest = backend.addMember(group.id, name: 'Guest');
    await repository.refresh();

    await repository.remove(repository.member(guest.id)!);
    expect(repository.member(guest.id), isNull);
    expect(repository.group(group.id), isNotNull);

    await repository.remove(repository.ownMember(group.id)!);
    expect(repository.group(group.id), isNull);
  });

  test('refreshGroup forgets a group the user can no longer see', () async {
    final group = backend.addGroup('Group');
    await repository.refresh();
    backend.members.removeWhere((_, m) => m.groupId == group.id);

    final result = await repository.refreshGroup(group.id);

    expect(errorOf(result), isA<NotFoundException>());
    expect(repository.group(group.id), isNull);
  });

  test('data survives a restart, for the same user only', () async {
    backend.addGroup('Group');
    await repository.refresh();
    await pumpEventQueue(); // the save is scheduled, not awaited

    cache = await openCache(); // as on the next app start
    final restarted = newRepository();
    restarted.switchUser('me');
    expect(restarted.groups, hasLength(1));

    final otherUser = newRepository();
    otherUser.switchUser('someone else');
    expect(otherUser.groups, isEmpty);
  });

  test('signing out forgets the data, on the device too', () async {
    backend.addGroup('Group');
    await repository.refresh();
    await pumpEventQueue();

    repository.switchUser(null);
    expect(repository.groups, isEmpty);

    await pumpEventQueue();
    cache = await openCache();
    final restarted = newRepository();
    restarted.switchUser('me');
    expect(restarted.groups, isEmpty);
  });

  test('a request still running when the user changes is discarded', () async {
    backend.addGroup('Theirs');
    backend.gate = Completer();
    final refresh = repository.refresh();

    repository.switchUser('someone else');
    backend.gate!.complete();
    await refresh;

    expect(repository.groups, isEmpty);
  });
}
