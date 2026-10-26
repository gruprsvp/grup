// The paid features' view models, over the real repositories and the fake
// backend: the kitchen view, the export, cutoff locks, the plan page and
// Settings → Billing.
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/view_models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

import '../support/fake_backend.dart';
import '../support/harness.dart';

void main() {
  // An event 30 minutes from now; with a 60-minute cutoff, changes closed
  // half an hour ago. Occurrences carry the wall-clock time in UTC fields.
  final soon = DateTime.now().add(const Duration(minutes: 30));
  final at = DateTime.utc(
    soon.year,
    soon.month,
    soon.day,
    soon.hour,
    soon.minute,
  );
  final day = DateTime(soon.year, soon.month, soon.day);
  final closed = DateTime(
    soon.year,
    soon.month,
    soon.day,
    soon.hour,
    soon.minute,
  ).subtract(const Duration(minutes: 60));

  late FakeBackend backend;
  late Repositories repositories;
  late Group club;
  late Member me;
  late Member ann;
  late Member guest;
  late Member bob;
  late Schedule dinner;

  setUp(() async {
    (backend, repositories) = await fakeApp(
      seed: (backend) {
        club = backend.addGroup('Club');
        me = backend.members.values.single;
        backend.addProfile('ann', name: 'Ann');
        backend.addProfile('bob', name: 'Bob');
        ann = backend.addMember(club.id, profileId: 'ann');
        bob = backend.addMember(club.id, profileId: 'bob');
        guest = backend.addMember(club.id, name: 'Guest');
        dinner = backend.addSchedule(club.id, start: at);
        backend.schedules[dinner.id] = dinner = dinner.copyWith(
          cutoffMinutesBefore: 60,
          timeZone: 'Europe/Zurich',
        );
        backend.fundGroup(club.id);
        // Ann changed her mind after changes closed; the others in time.
        backend.addReply(
          Reply(
            memberId: ann.id,
            scheduleId: dinner.id,
            instanceDate: at,
            selectedOption: ReplyOptions.yes,
            updatedAt: closed.add(const Duration(minutes: 10)),
          ),
        );
        for (final (member, option) in [
          (guest, ReplyOptions.yes),
          (bob, ReplyOptions.no),
        ]) {
          backend.addReply(
            Reply(
              memberId: member.id,
              scheduleId: dinner.id,
              instanceDate: at,
              selectedOption: option,
              updatedAt: closed.subtract(const Duration(days: 1)),
            ),
          );
        }
      },
    );
  });

  test('the kitchen counts who is coming, by account and guest, and who '
      'changed late', () async {
    final vm = GroupKitchenViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      billing: repositories.billing,
      date: day,
    );
    addTearDown(vm.dispose);
    await pumpEventQueue();

    final event = vm.events.single;
    expect(event.coming.map((m) => m.$1.id), [ann.id, guest.id]);
    expect(
      (event.members, event.guests, event.no, event.noReply),
      (1, 1, 1, 1),
    );
    expect(event.late.map((m) => m.$1.id), [ann.id]);
    expect(vm.access.show(FeatureKey.kitchenView), isTrue);
  });

  test('late changes need the cutoff feature', () async {
    backend.billingMode = BillingMode.prelaunch;
    final vm = GroupKitchenViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      billing: repositories.billing,
      date: day,
    );
    addTearDown(vm.dispose);
    await pumpEventQueue();

    expect(vm.events.single.late, isEmpty);
    expect(vm.access.show(FeatureKey.kitchenView), isFalse);
  });

  group('after the deadline', () {
    test('the group page says changes closed, with the feature', () async {
      final vm = GroupDetailsViewModel(
        groupId: club.id,
        groups: repositories.groups,
        schedules: repositories.schedules,
        billing: repositories.billing,
        date: day,
      );
      addTearDown(vm.dispose);
      await pumpEventQueue();

      expect(vm.closedAt(vm.instances.single), closed);

      backend.billingMode = BillingMode.prelaunch;
      await repositories.billing.refresh();
      expect(vm.closedAt(vm.instances.single), isNull);
    });

    test('the event page shows admins who changed late', () async {
      final vm = ScheduleDetailsViewModel(
        groupId: club.id,
        scheduleId: dinner.id,
        instanceDate: at,
        groups: repositories.groups,
        schedules: repositories.schedules,
        billing: repositories.billing,
      );
      addTearDown(vm.dispose);
      await pumpEventQueue();

      expect(vm.closedAt, closed);
      expect(vm.lateMembers, {ann.id});
    });

    test('a member is refused, an admin is not', () async {
      final vm = GroupDetailsViewModel(
        groupId: club.id,
        groups: repositories.groups,
        schedules: repositories.schedules,
        billing: repositories.billing,
        date: day,
      );
      addTearDown(vm.dispose);
      await pumpEventQueue();

      // The user is the admin: answering still works.
      expect(
        await vm.reply(vm.instances.single, ReplyOptions.yes),
        isA<Ok<void>>(),
      );
      // ...but not clearing it.
      final cleared = await vm.reply(vm.instances.single, null);
      expect((cleared as Error).error, isA<ReplyLockedException>());

      backend.members[me.id] = me.copyWith(role: GroupRoles.member);
      await repositories.groups.refresh();
      final refused = await vm.reply(vm.instances.single, ReplyOptions.no);
      expect((refused as Error).error, isA<ReplyLockedException>());
    });
  });

  group('GroupManageViewModel', () {
    GroupManageViewModel open() => GroupManageViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      billing: repositories.billing,
    );

    test('exports everyone\'s answers as CSV', () async {
      final vm = open();
      addTearDown(vm.dispose);
      await pumpEventQueue();

      await vm.export.execute((first: day, last: day));

      final csv = (vm.export.result as Ok<String>).value;
      final lines = csv.trim().split('\r\n');
      expect(lines.first, 'date,time,event,name,managed,answer,source,late');
      expect(lines, hasLength(5));
      expect(
        lines.where((l) => l.contains(',Ann,')).single,
        endsWith(',yes,reply,yes'),
      );
      expect(
        lines.where((l) => l.contains(',Guest,')).single,
        contains(',yes,yes,reply,no'),
      );
      expect(
        lines.where((l) => l.contains(',Me,')).single,
        endsWith(',,none,no'),
      );
    });

    test('sets a cutoff, with the device time zone', () async {
      final vm = open();
      addTearDown(vm.dispose);
      await pumpEventQueue();
      backend.timeZone = 'America/New_York';

      await vm.setCutoff.execute((schedule: dinner, minutes: 120));

      expect(vm.setCutoff.result, isA<Ok<Schedule>>());
      final saved = vm.schedules.single;
      expect(
        (saved.cutoffMinutesBefore, saved.timeZone),
        (120, 'America/New_York'),
      );
    });
  });

  test('a refused cutoff refreshes what the plan allows', () async {
    final vm = GroupManageViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      billing: repositories.billing,
    );
    addTearDown(vm.dispose);
    await pumpEventQueue();
    expect(vm.access.show(FeatureKey.replyCutoffs), isTrue);

    // The plan lapsed while the page was open.
    backend.entitlements.remove(club.id);
    await vm.setCutoff.execute((schedule: dinner, minutes: 30));

    expect((vm.setCutoff.result as Error).error, isA<FeatureLockedException>());
    expect(vm.access.show(FeatureKey.replyCutoffs), isFalse);
  });

  group('GroupPlanViewModel', () {
    test('knows who pays, and offers them the portal', () async {
      backend.entitlements[club.id] = backend.entitlements[club.id]!.copyWith(
        sources: const [
          EntitlementSource(
            kind: 'subscription',
            plan: 'community_m',
            rank: 20,
            payer: 'me',
            status: 'active',
          ),
        ],
      );
      final vm = GroupPlanViewModel(
        groupId: club.id,
        groups: repositories.groups,
        billing: repositories.billing,
      );
      addTearDown(vm.dispose);
      await pumpEventQueue();

      expect(vm.isPayer, isTrue);
      expect(vm.nameOf('ann'), 'Ann');

      await vm.manage.execute();
      expect(vm.manage.result, isA<Ok<Uri>>());
      expect(backend.portals, ['/groups/${club.id}/plan']);
    });

    test('back from Checkout, it notices when the plan is on', () async {
      final vm = GroupPlanViewModel(
        groupId: club.id,
        groups: repositories.groups,
        billing: repositories.billing,
        checkoutSuccess: true,
      );
      addTearDown(vm.dispose);
      await pumpEventQueue();
      expect((vm.activating, vm.activated), (true, false));

      backend.entitlements[club.id] = backend.entitlements[club.id]!.copyWith(
        sources: const [
          EntitlementSource(
            kind: 'subscription',
            plan: 'community_s',
            rank: 10,
            payer: 'me',
            status: 'active',
          ),
        ],
      );
      await repositories.billing.refresh();

      expect((vm.activating, vm.activated), (false, true));
    });

    test(
      'a checkout for a funded group is refused and shows the plan',
      () async {
        final vm = GroupPlanViewModel(
          groupId: club.id,
          groups: repositories.groups,
          billing: repositories.billing,
        );
        addTearDown(vm.dispose);
        await pumpEventQueue();
        backend.stripeFailure = const AlreadyFundedException();

        await vm.subscribe.execute((plan: 'community_s', interval: 'month'));

        expect(
          (vm.subscribe.result as Error).error,
          isA<AlreadyFundedException>(),
        );
        expect(vm.isPayer, isFalse);
      },
    );
  });

  group('SettingsViewModel', () {
    SettingsViewModel open() => SettingsViewModel(
      settings: repositories.settings,
      auth: repositories.auth,
      profile: repositories.profile,
      billing: repositories.billing,
    );

    test('shows billing on the web to those who paid there', () async {
      debugIsWeb = true;
      addTearDown(() => debugIsWeb = null);
      backend.isCustomer = true;
      final vm = open();
      addTearDown(vm.dispose);
      await pumpEventQueue();

      expect(vm.showBilling, isTrue);
      await vm.manageBilling.execute();
      expect(backend.portals, ['/settings']);
    });

    test('not in the apps, nor to who never paid', () async {
      backend.isCustomer = true;
      final vm = open();
      addTearDown(vm.dispose);
      await pumpEventQueue();
      expect(vm.showBilling, isFalse);

      debugIsWeb = true;
      addTearDown(() => debugIsWeb = null);
      backend.isCustomer = false;
      await repositories.billing.refresh();
      expect(vm.showBilling, isFalse);
    });
  });
}
