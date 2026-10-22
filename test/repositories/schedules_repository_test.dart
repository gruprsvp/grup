import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' show ClientException;
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/schedules.dart';
import 'package:parousia/services/local_cache.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import '../support/fake_backend.dart';
import '../support/preferences.dart';

void main() {
  late FakeBackend backend;
  late LocalCache cache;
  late SchedulesRepository repository;
  late Group group;
  late Member me;
  late Schedule dinner;

  final day = DateTime.utc(2024, 1, 2, 18);
  final window = day.getNdayRange(1);

  setUp(() async {
    backend = FakeBackend();
    useInMemoryPreferences();
    cache = await openCache();
    repository = SchedulesRepository(
      schedules: backend.schedulesService,
      defaultRules: backend.defaultRulesService,
      replies: backend.repliesService,
      cache: cache,
    );
    repository.switchUser('me');
    group = backend.addGroup('Group');
    me = backend.members.values.single;
    dinner = backend.addSchedule(group.id);
  });

  Reply reply(ReplyOptions option, {Member? member}) => Reply(
    memberId: (member ?? me).id,
    scheduleId: dinner.id,
    instanceDate: day,
    selectedOption: option,
  );

  test(
    'load fetches the schedules, default rules and replies of a group',
    () async {
      backend.addReply(reply(ReplyOptions.yes));
      backend.defaultRules[(me.id, dinner.id)] = DefaultRule(
        memberId: me.id,
        scheduleId: dinner.id,
        selectedOption: ReplyOptions.no,
        recurrenceRule: CommonRecurrenceRules.weekends,
      );

      await repository.load(group.id, window);

      expect(repository.schedules(group.id).single.id, dinner.id);
      expect(
        repository.replies(group.id).single.selectedOption,
        ReplyOptions.yes,
      );
      expect(
        repository.defaultRules(group.id).single.selectedOption,
        ReplyOptions.no,
      );
    },
  );

  test('load drops what someone else deleted', () async {
    final other = backend.addSchedule(group.id, name: 'Lunch');
    backend.addReply(reply(ReplyOptions.yes));
    await repository.load(group.id, window);

    backend.schedules.remove(other.id);
    backend.replies.clear();
    await repository.load(group.id, window);

    expect(repository.schedules(group.id).map((s) => s.id), [dinner.id]);
    expect(repository.replies(group.id), isEmpty);
  });

  test('load leaves other groups alone', () async {
    final otherGroup = backend.addGroup('Other');
    final otherSchedule = backend.addSchedule(otherGroup.id);
    await repository.load(otherGroup.id, window);

    await repository.load(group.id, window);

    expect(repository.schedules(otherGroup.id).single.id, otherSchedule.id);
  });

  test('a reply shows up before the server answers', () async {
    await repository.load(group.id, window);

    final saving = repository.reply(
      memberId: me.id,
      scheduleId: dinner.id,
      instanceDate: day,
      option: ReplyOptions.yes,
    );
    expect(
      repository.replies(group.id).single.selectedOption,
      ReplyOptions.yes,
    );

    expect(await saving, isA<Ok<void>>());
    expect(backend.replies.values.single.selectedOption, ReplyOptions.yes);
  });

  test('a reply the server refuses is undone', () async {
    backend.addReply(reply(ReplyOptions.no));
    await repository.load(group.id, window);

    backend.failure = ClientException('offline');
    final result = await repository.reply(
      memberId: me.id,
      scheduleId: dinner.id,
      instanceDate: day,
      option: ReplyOptions.yes,
    );

    expect((result as Error).error, isA<NetworkException>());
    expect(repository.replies(group.id).single.selectedOption, ReplyOptions.no);
  });

  test(
    'clearing a reply deletes it; clearing a missing one is undone',
    () async {
      backend.addReply(reply(ReplyOptions.yes));
      await repository.load(group.id, window);

      Future<Result<void>> clear() => repository.reply(
        memberId: me.id,
        scheduleId: dinner.id,
        instanceDate: day,
        option: null,
      );

      expect(await clear(), isA<Ok<void>>());
      expect(repository.replies(group.id), isEmpty);
      expect(backend.replies, isEmpty);

      // Someone else already removed it: the delete fails rather than lie.
      backend.addReply(reply(ReplyOptions.yes));
      await repository.load(group.id, window);
      backend.replies.clear();
      final result = await clear();
      expect((result as Error).error, isA<NotFoundException>());
      expect(repository.replies(group.id), hasLength(1));
    },
  );

  test('a default rule is set and removed optimistically', () async {
    await repository.load(group.id, window);

    await repository.setDefaultRule(
      memberId: me.id,
      scheduleId: dinner.id,
      rule: CommonRecurrenceRules.weekdays,
      option: ReplyOptions.yes,
    );
    expect(
      repository.defaultRules(group.id).single.selectedOption,
      ReplyOptions.yes,
    );
    expect(backend.defaultRules, hasLength(1));

    await repository.setDefaultRule(
      memberId: me.id,
      scheduleId: dinner.id,
      rule: null,
      option: null,
    );
    expect(repository.defaultRules(group.id), isEmpty);
    expect(backend.defaultRules, isEmpty);
  });

  test('deleting a schedule takes its replies and rules along', () async {
    backend.addReply(reply(ReplyOptions.yes));
    await repository.load(group.id, window);

    await repository.delete(dinner);

    expect(repository.schedules(group.id), isEmpty);
    expect(repository.replies(group.id), isEmpty);
  });

  test('data survives a restart', () async {
    backend.addReply(reply(ReplyOptions.yes));
    await repository.load(group.id, window);
    await pumpEventQueue();

    cache = await openCache(); // as on the next app start
    final restarted = SchedulesRepository(
      schedules: backend.schedulesService,
      defaultRules: backend.defaultRulesService,
      replies: backend.repliesService,
      cache: cache,
    );
    restarted.switchUser('me');

    expect(
      restarted.schedules(group.id).single.recurrenceRule,
      dinner.recurrenceRule,
    );
    expect(restarted.replies(group.id).single.instanceDate, day);
  });
}
