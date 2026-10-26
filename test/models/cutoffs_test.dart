// Reply cutoffs and the answers export (docs/billing-and-entitlements.md 9.2,
// 9.4): when changes close, who changed late, and the CSV.
import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/datetime.dart';
import 'package:parousia/util/recurrence_rules.dart';

void main() {
  // Occurrences carry the wall-clock time in UTC fields: 18:00 on 10 March.
  final at = DateTime.utc(2026, 3, 10, 18);
  final dinner = Schedule(
    id: 'dinner',
    groupId: 'club',
    displayName: 'Dinner',
    startDate: DateTime.utc(2026, 3, 1, 18),
    recurrenceRule: CommonRecurrenceRules.daily,
    cutoffMinutesBefore: 60,
    timeZone: 'Europe/Zurich',
  );
  const ann = Member(
    id: 'ann',
    groupId: 'club',
    role: GroupRoles.member,
    profileId: 'u-ann',
  );
  const bob = Member(
    id: 'bob',
    groupId: 'club',
    role: GroupRoles.member,
    profileId: 'u-bob',
  );
  const cy = Member(
    id: 'cy',
    groupId: 'club',
    role: GroupRoles.member,
    displayNameOverride: 'Cy',
  );

  Reply reply(Member member, ReplyOptions option, DateTime updatedAt) => Reply(
    memberId: member.id,
    scheduleId: dinner.id,
    instanceDate: at,
    selectedOption: option,
    updatedAt: updatedAt,
  );

  DefaultRule usual(Member member, ReplyOptions option, DateTime updatedAt) =>
      DefaultRule(
        memberId: member.id,
        scheduleId: dinner.id,
        selectedOption: option,
        recurrenceRule: CommonRecurrenceRules.daily,
        updatedAt: updatedAt,
      );

  ScheduleInstanceSummary resolve({
    List<Reply> replies = const [],
    List<DefaultRule> rules = const [],
  }) => getScheduleInstances(
    schedule: dinner,
    startDate: at.getDayStart(),
    endDate: at.getDayEnd(),
    members: const [ann, bob, cy],
    defaultRules: rules,
    replies: replies,
  ).single;

  group('closesAt', () {
    test('is the start, on the device clock, minus the cutoff', () {
      expect(dinner.startsAt(at), DateTime(2026, 3, 10, 18));
      expect(dinner.closesAt(at), DateTime(2026, 3, 10, 17));
    });

    test('is null without a cutoff', () {
      expect(dinner.copyWith(cutoffMinutesBefore: null).closesAt(at), isNull);
    });
  });

  group('lateMemberIds', () {
    final closes = DateTime(2026, 3, 10, 17);
    final starts = DateTime(2026, 3, 10, 18);

    test('a reply changed after the deadline and before the start is late', () {
      final replies = [
        reply(ann, ReplyOptions.yes, closes.add(const Duration(minutes: 30))),
        reply(
          bob,
          ReplyOptions.no,
          closes.subtract(const Duration(minutes: 1)),
        ),
        reply(cy, ReplyOptions.yes, starts.add(const Duration(minutes: 5))),
      ];
      expect(lateMemberIds(dinner, resolve(replies: replies), replies), {
        'ann',
      });
    });

    test('the deadline itself is already late', () {
      final replies = [reply(ann, ReplyOptions.yes, closes)];
      expect(lateMemberIds(dinner, resolve(replies: replies), replies), {
        'ann',
      });
    });

    test('a usual answer changed late counts, unless a reply overrides it', () {
      final late = closes.add(const Duration(minutes: 10));
      final rules = [
        usual(ann, ReplyOptions.yes, late),
        usual(bob, ReplyOptions.yes, late),
      ];
      final replies = [
        reply(bob, ReplyOptions.no, closes.subtract(const Duration(hours: 1))),
      ];
      expect(
        lateMemberIds(dinner, resolve(replies: replies, rules: rules), replies),
        {'ann'},
      );
    });

    test('nothing is late without a cutoff', () {
      final schedule = dinner.copyWith(cutoffMinutesBefore: null);
      final replies = [
        reply(ann, ReplyOptions.yes, closes.add(const Duration(minutes: 30))),
      ];
      expect(
        lateMemberIds(schedule, resolve(replies: replies), replies),
        isEmpty,
      );
    });
  });
}
