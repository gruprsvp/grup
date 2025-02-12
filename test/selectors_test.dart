import 'dart:math';

import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/state/state.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:supabase/supabase.dart' show User;
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('selectors', () {
    test('mismatch between detail and list view in yes count', () {
      final uuid = Uuid();

      final date = DateTime.utc(2022, 1, 1, 12);

      final authUser = User(
        id: uuid.v4(),
        appMetadata: {},
        userMetadata: null,
        aud: 'aud',
        createdAt: DateTime.now().toIso8601String(),
      );

      final profiles = [
        Profile(
          id: authUser.id,
          displayName: 'current user',
        ),
        for (var i = 0; i < 10; i++)
          Profile(
            id: uuid.v4(),
            displayName: 'user $i',
          ),
      ];

      final group = Group(
        id: 'group',
        displayName: 'group',
      );

      Member createMember({Profile? profile}) => Member(
            group: group,
            profile: profile,
            role: GroupRoles.member,
          );
      final members = [
        for (final profile in profiles) createMember(profile: profile),
      ];

      final schedules = [
        Schedule(
            group: group,
            displayName: 'schedule 1',
            startDate: date,
            recurrenceRule: CommonRecurrenceRules.daily,
            timezone: 'Europe/Zurich'),
      ];

      Reply createReply(Member member, Schedule schedule, DateTime date) =>
          Reply(
            member: member,
            schedule: schedule,
            instanceDate: date,
            selectedOption:
                Random().nextBool() ? ReplyOptions.yes : ReplyOptions.no,
          );
      final replies = [
        for (final schedule in schedules) ...[
          // create a reply for a member that no longer exists
          Reply(
            member: createMember(),
            schedule: schedule,
            instanceDate: date,
            selectedOption: ReplyOptions.yes,
          ),
          for (final member in members) createReply(member, schedule, date),
        ]
      ];

      final state = AppState(
        selectedDate: date,
        auth: AuthState(status: AuthStatus.authenticated, user: authUser),
        profiles: RemoteEntityState<Profile>(entities: {
          for (final profile in profiles) profile.id: profile,
        }),
        groups: RemoteEntityState<Group>(entities: {group.id: group}),
        members: RemoteEntityState<Member>(entities: {
          for (final member in members) member.id: member,
        }),
        schedules: RemoteEntityState<Schedule>(entities: {
          for (final schedule in schedules) schedule.id: schedule,
        }),
        defaultRules: RemoteEntityState<DefaultRule>(entities: {
          // TODO Does it happen with default rules?
        }),
        replies: RemoteEntityState<Reply>(entities: {
          for (final reply in replies)
            "${reply.memberId}-${reply.scheduleId}-${reply.instanceDate}":
                reply,
        }),
        selectedGroupId: group.id,
        // selectedScheduleId: // TODO
      );

      final result = selectScheduleInstancesForSelectedDate(state);

      for (final instance in result) {
        final state2 = state.copyWith(selectedScheduleId: instance.schedule.id);
        final instance2 = selectScheduleInstanceForDate(state2);

        expect(
            instance2?.repliesGroups
                .firstWhere((e) => e.reply == ReplyOptions.yes)
                .count,
            equals(instance.yesCount));
      }
    });
  });
}
