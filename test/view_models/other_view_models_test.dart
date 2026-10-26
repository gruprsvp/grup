import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/view_models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:rrule/rrule.dart';

import '../support/fake_backend.dart';
import '../support/harness.dart';

void main() {
  late FakeBackend backend;
  late Repositories repositories;
  late Group club;

  setUp(() async {
    (backend, repositories) = await fakeApp(
      seed: (backend) {
        backend.addProfile('me', name: 'Alex');
        club = backend.addGroup('Club');
      },
    );
    await repositories.groups.refresh();
  });

  group('GroupManageViewModel', () {
    GroupManageViewModel open() => GroupManageViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      billing: repositories.billing,
    );

    test('creates and deletes events', () async {
      final vm = open();

      await vm.createSchedule.execute(
        Schedule(
          id: '',
          groupId: '',
          displayName: 'Dinner',
          startDate: DateTime.utc(2024, 1, 1, 18),
          recurrenceRule: RecurrenceRule(frequency: Frequency.weekly),
        ),
      );
      expect(vm.schedules.single.groupId, club.id);

      await vm.deleteSchedule.execute(vm.schedules.single);
      expect(vm.schedules, isEmpty);
    });

    test('invites, and lists the new members', () async {
      final vm = open();

      await vm.invite.execute(const [
        ContactInvite(displayNameOverride: 'Ann', invites: []),
      ]);

      expect(
        vm.members.map((m) => m.$1.displayNameOverride ?? m.$2?.displayName),
        containsAll(['Ann', 'Alex']),
      );
    });

    test('deleting the group says whether it worked', () async {
      final vm = open();

      await vm.delete.execute();
      expect(vm.delete.completed, isTrue);
      expect(vm.group, isNull);

      await vm.delete.execute();
      expect((vm.delete.result! as Error).error, isA<NotFoundException>());
    });
  });

  group('MemberDetailsViewModel', () {
    test('knows the user, loads invites, and lets them leave', () async {
      final own = repositories.groups.ownMember(club.id)!;
      final guest = backend.addMember(club.id, name: 'Guest');
      await backend.invitesService.inviteWithGeneratedCode(guest.id);

      final guestVm = MemberDetailsViewModel(
        groupId: club.id,
        memberId: guest.id,
        groups: repositories.groups,
      );
      await pumpEventQueue();
      expect(guestVm.isCurrentUser, isFalse);
      expect(guestVm.invites?.single.method, InviteMethods.code);

      final ownVm = MemberDetailsViewModel(
        groupId: club.id,
        memberId: own.id,
        groups: repositories.groups,
      );
      expect(ownVm.isCurrentUser, isTrue);

      await ownVm.remove.execute();
      expect(ownVm.remove.completed, isTrue);
      expect(repositories.groups.group(club.id), isNull);
    });
  });

  group('ProfileViewModel', () {
    test('a new name also shows in the group member lists', () async {
      final vm = ProfileViewModel(
        profile: repositories.profile,
        groups: repositories.groups,
      );

      await vm.save.execute((name: 'Sam', image: null));

      expect(vm.profile?.displayName, 'Sam');
      expect(repositories.groups.profile('me')?.displayName, 'Sam');
    });
  });

  group('SettingsViewModel', () {
    SettingsViewModel open() => SettingsViewModel(
      settings: repositories.settings,
      auth: repositories.auth,
      profile: repositories.profile,
      billing: repositories.billing,
    );

    test('switches theme and language', () {
      final vm = open();

      vm.nextThemeMode();
      vm.setLocale(const Locale('fr'));

      expect(vm.themeMode, ThemeMode.light);
      expect(vm.locale, const Locale('fr'));
    });

    test(
      "signing out forgets the user's data but keeps the settings",
      () async {
        final vm = open();
        vm.nextThemeMode();

        await vm.signOut.execute();
        await pumpEventQueue();

        expect(repositories.auth.isAuthenticated, isFalse);
        expect(repositories.groups.groups, isEmpty);
        expect(repositories.profile.profile, isNull);
        expect(vm.themeMode, ThemeMode.light);
      },
    );

    test('deleting the account signs out', () async {
      final vm = open();

      await vm.deleteAccount.execute();
      await pumpEventQueue();

      expect(vm.deleteAccount.completed, isTrue);
      expect(repositories.auth.isAuthenticated, isFalse);
    });
  });
}
