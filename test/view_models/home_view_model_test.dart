import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/view_models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/recurrence_rules.dart';
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
      schedules: repositories.schedules,
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
      schedules: repositories.schedules,
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
      schedules: repositories.schedules,
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
      schedules: repositories.schedules,
    );
    await pumpEventQueue();

    expect(vm.showFeedbackCard, isFalse);
  });

  test('asks once about analytics, whatever the answer', () async {
    final (_, repositories) = await fakeApp();
    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
      schedules: repositories.schedules,
    );
    expect(vm.showAnalyticsCard, isTrue);

    vm.setAnalytics(false);

    expect(vm.showAnalyticsCard, isFalse);
    expect(repositories.settings.analytics, isFalse);
  });

  test('creates groups, and explains a wrong invite code', () async {
    final (backend, repositories) = await fakeApp();
    backend.addProfile('me', name: 'Alex');
    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
      schedules: repositories.schedules,
    );

    await vm.create.execute((
      group: const Group(id: '', displayName: 'New'),
      image: null,
    ));
    expect(vm.groups.map((g) => g.displayName), ['New']);

    await vm.join.execute('NOPE-NOPE');
    expect((vm.join.result! as Error).error, isA<InvalidInviteCodeException>());
  });

  test("shows each group's next event, with who's coming", () async {
    final (backend, repositories) = await fakeApp();
    final club = backend.addGroup('Club');
    final me = backend.members.values.single;
    // Tomorrow, in the wall-clock-as-UTC-fields form occurrences use.
    final now = DateTime.now();
    final at = DateTime.utc(now.year, now.month, now.day + 1, 18);
    final dinner = backend.addSchedule(
      club.id,
      start: at,
      rule: CommonRecurrenceRules.weekly,
    );
    backend.addReply(
      Reply(
        memberId: me.id,
        scheduleId: dinner.id,
        instanceDate: at,
        selectedOption: ReplyOptions.yes,
      ),
    );
    final far = backend.addGroup('Far');
    backend.addSchedule(
      far.id,
      start: at.add(const Duration(days: HomeViewModel.lookahead + 1)),
      rule: CommonRecurrenceRules.once,
    );

    final vm = HomeViewModel(
      groups: repositories.groups,
      profile: repositories.profile,
      settings: repositories.settings,
      schedules: repositories.schedules,
    );
    await pumpEventQueue();

    final next = vm.nextEvent(club.id)!;
    expect(next.event.instanceDate, at);
    expect(next.event.confirmedYes, 1);
    expect(next.counted, isTrue);
    expect(
      vm.nextEvent(far.id)!.counted,
      isFalse,
      reason: 'its answers are beyond the loaded window',
    );
  });
}
