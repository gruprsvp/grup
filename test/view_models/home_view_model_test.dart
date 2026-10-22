import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/view_models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

import '../support/harness.dart';

void main() {
  test('loads the groups and the profile when created', () async {
    final (backend, repositories) = await fakeApp();
    backend.addGroup('Book Club');
    backend.addProfile('me', name: 'Alex');

    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
    );
    await pumpEventQueue();

    expect(vm.groups.map((g) => g.displayName), ['Book Club']);
    expect(vm.profile?.displayName, 'Alex');
    expect(vm.needsName, isFalse);
  });

  test('asks for a name until the user has one', () async {
    final (backend, repositories) = await fakeApp();
    backend.addProfile('me');

    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
    );
    expect(vm.needsName, isFalse, reason: 'not before the profile loads');
    await pumpEventQueue();

    expect(vm.needsName, isTrue);
  });

  test('asks for feedback after three days, until dismissed', () async {
    final (backend, repositories) = await fakeApp();
    backend.addProfile(
      'me',
      name: 'Alex',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    );
    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
    );
    await pumpEventQueue();
    expect(vm.showFeedbackCard, isTrue);

    vm.dismissFeedback();

    expect(vm.showFeedbackCard, isFalse);
  });

  test('does not ask new users for feedback', () async {
    final (backend, repositories) = await fakeApp();
    backend.addProfile('me', name: 'Alex', createdAt: DateTime.now());
    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
    );
    await pumpEventQueue();

    expect(vm.showFeedbackCard, isFalse);
  });

  test('creates groups, and explains a wrong invite code', () async {
    final (backend, repositories) = await fakeApp();
    backend.addProfile('me', name: 'Alex');
    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
    );

    await vm.create.execute((
      group: const Group(id: '', displayName: 'New'),
      image: null,
    ));
    expect(vm.groups.map((g) => g.displayName), ['New']);

    await vm.join.execute('NOPE-NOPE');
    expect((vm.join.result! as Error).error, isA<InvalidInviteCodeException>());
  });
}
