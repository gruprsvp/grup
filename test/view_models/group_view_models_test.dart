import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;
import 'package:parousia/dependencies.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/presentation/view_models/view_models.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:parousia/util/result.dart';

import '../support/fake_backend.dart';
import '../support/harness.dart';

void main() {
  // The user's calendar day (a local date), and that day's dinner.
  final day = DateTime(2024, 1, 2);
  final dinnerAt = DateTime.utc(2024, 1, 2, 18);

  late FakeBackend backend;
  late Repositories repositories;
  late Group club;
  late Member me;
  late Schedule dinner;

  setUp(() async {
    (backend, repositories) = await fakeApp(
      seed: (backend) {
        club = backend.addGroup('Club');
        me = backend.members.values.single;
        dinner = backend.addSchedule(
          club.id,
          start: DateTime.utc(2024, 1, 1, 18),
        );
      },
    );
  });

  Reply reply(Member member, ReplyOptions option, {DateTime? at}) => Reply(
    memberId: member.id,
    scheduleId: dinner.id,
    instanceDate: at ?? dinnerAt,
    selectedOption: option,
  );

  Future<GroupDetailsViewModel> openGroup() async {
    final vm = GroupDetailsViewModel(
      groupId: club.id,
      groups: repositories.groups,
      schedules: repositories.schedules,
      date: day,
    );
    await pumpEventQueue();
    return vm;
  }

  Future<ScheduleDetailsViewModel> openDinner() async {
    final vm = ScheduleDetailsViewModel(
      groupId: club.id,
      scheduleId: dinner.id,
      instanceDate: dinnerAt,
      groups: repositories.groups,
      schedules: repositories.schedules,
    );
    await pumpEventQueue();
    return vm;
  }

  group('GroupDetailsViewModel', () {
    test("lists the day's occurrences with the user's answer", () async {
      backend.addReply(reply(me, ReplyOptions.yes));

      final vm = await openGroup();

      final instance = vm.instances.single;
      expect(instance.instanceDate, dinnerAt);
      expect(instance.myReply, ReplyOptions.yes);
      expect(instance.yesCount, 1);
      expect(vm.isAdmin, isTrue);
    });

    test('an answer at midnight counts (the old filter dropped it)', () async {
      final midnight = backend.addSchedule(
        club.id,
        start: DateTime.utc(2024, 1, 1),
      );
      backend.addReply(
        Reply(
          memberId: me.id,
          scheduleId: midnight.id,
          instanceDate: DateTime.utc(2024, 1, 2),
          selectedOption: ReplyOptions.yes,
        ),
      );

      final vm = await openGroup();

      final instance = vm.instances.firstWhere(
        (i) => i.scheduleId == midnight.id,
      );
      expect(instance.myReply, ReplyOptions.yes);
    });

    test('a schedule that starts later has no occurrence that day', () async {
      backend.addSchedule(club.id, start: DateTime.utc(2024, 1, 5, 18));

      final vm = await openGroup();

      expect(vm.instances.map((i) => i.scheduleId), [dinner.id]);
    });

    test('a reply shows at once, and is undone if it fails', () async {
      final vm = await openGroup();

      final saved = vm.reply(vm.instances.single, ReplyOptions.yes);
      expect(vm.instances.single.myReply, ReplyOptions.yes);
      expect(await saved, isA<Ok<void>>());

      backend.failure = ClientException('offline');
      final failed = await vm.reply(vm.instances.single, ReplyOptions.no);
      expect((failed as Error).error, isA<NetworkException>());
      expect(vm.instances.single.myReply, ReplyOptions.yes);
    });

    test('changing the date loads the replies around the new date', () async {
      final later = DateTime.utc(2024, 1, 10, 18);
      backend.addReply(reply(me, ReplyOptions.no, at: later));
      final vm = await openGroup();

      vm.selectDate(DateTime(2024, 1, 10));
      await pumpEventQueue();

      expect(vm.instances.single.instanceDate, later);
      expect(vm.instances.single.myReply, ReplyOptions.no);
    });
  });

  group('GroupDetailsViewModel without a date', () {
    test('opens on the next event when today has none', () async {
      // Weekly, starting three days from now: today is empty.
      final now = DateTime.now();
      final start = DateTime.utc(now.year, now.month, now.day + 3, 18);
      backend.schedules.remove(dinner.id);
      final game = backend.addSchedule(
        club.id,
        name: 'Game',
        start: start,
        rule: CommonRecurrenceRules.weekly,
      );

      final vm = GroupDetailsViewModel(
        groupId: club.id,
        groups: repositories.groups,
        schedules: repositories.schedules,
      );
      await pumpEventQueue();

      expect(vm.date, DateTime(start.year, start.month, start.day));
      expect(vm.instances.single.scheduleId, game.id);
      // And the empty-day hint points a week on.
      expect(vm.next?.$2, start.add(const Duration(days: 7)));
    });

    test('stays on today when today has an event', () async {
      final vm = GroupDetailsViewModel(
        groupId: club.id,
        groups: repositories.groups,
        schedules: repositories.schedules,
      );
      await pumpEventQueue();

      final now = DateTime.now();
      expect(
        (vm.date.year, vm.date.month, vm.date.day),
        (now.year, now.month, now.day),
      );
      expect(vm.instances.single.scheduleId, dinner.id);
    });
  });

  group('ScheduleDetailsViewModel', () {
    test('groups the members by answer, counting the user too', () async {
      final ann = backend.addMember(club.id, name: 'Ann');
      final bob = backend.addMember(club.id, name: 'Bob');
      backend
        ..addReply(reply(me, ReplyOptions.yes))
        ..addReply(reply(ann, ReplyOptions.no));

      final vm = await openDinner();

      // Each group's count, and who it lists, by answer.
      final groups = {
        for (final g in vm.details!.repliesGroups)
          g.reply: '${g.count}: ${g.members.map((m) => m.member.id).join(',')}',
      };
      expect(groups, {
        // Only the user answered yes: the group shows anyway, counting them.
        ReplyOptions.yes: '1: ',
        ReplyOptions.no: '1: ${ann.id}',
        null: '1: ${bob.id}',
      });
    });

    test('agrees with the group list on how many said yes', () async {
      final random = Random(42);
      for (var i = 0; i < 10; i++) {
        final member = backend.addMember(club.id, profileId: 'user-$i');
        backend.addReply(
          reply(member, random.nextBool() ? ReplyOptions.yes : ReplyOptions.no),
        );
      }
      // A reply by someone who has since left: counted in neither view.
      backend.addReply(
        Reply(
          memberId: 'gone',
          scheduleId: dinner.id,
          instanceDate: dinnerAt,
          selectedOption: ReplyOptions.yes,
        ),
      );

      final list = await openGroup();
      final details = await openDinner();

      final yes = details.details!.repliesGroups.firstWhere(
        (g) => g.reply == ReplyOptions.yes,
      );
      expect(yes.count, list.instances.single.yesCount);
    });
  });
}
