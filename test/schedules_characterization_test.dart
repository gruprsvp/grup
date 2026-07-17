// Characterization tests for the RSVP / recurrence resolution in
// `selectors/schedules.dart` (`getScheduleInstances` + `repliesForScheduleInstance`).
//
// These lock the CURRENT behavior of the most complex domain logic in the app so
// it can be safely refactored (e.g. the planned selector-memoization fixes) or,
// later, ported. They are pure and hermetic — no Supabase, no Flutter binding.
//
// Where a value depends on `rrule` boundary semantics (inclusive/exclusive window
// edges), the assertion encodes the observed behavior, not an assumption.

import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:rrule/rrule.dart';
import 'package:test/test.dart';

void main() {
  // 2024-01-01 is a Monday. All dates are UTC because rrule requires it and the
  // resolution logic normalizes everything to UTC midnight.
  final monday = DateTime.utc(2024, 1, 1);
  DateTime day(int n) => monday.add(Duration(days: n)); // day(0) == Monday

  const groupId = 'group-1';
  const memberA = 'member-a';
  const memberB = 'member-b';
  const memberC = 'member-c'; // intentionally NOT in the group

  Member member(String id) =>
      Member(id: id, groupId: groupId, role: GroupRoles.member);

  Schedule schedule(
    RecurrenceRule rule, {
    DateTime? start,
    String id = 'sched',
  }) => Schedule(
    id: id,
    groupId: groupId,
    displayName: 'Schedule $id',
    startDate: start ?? monday,
    recurrenceRule: rule,
  );

  DefaultRule defaultRule(
    String memberId,
    String scheduleId,
    ReplyOptions option,
    RecurrenceRule rule,
  ) => DefaultRule(
    memberId: memberId,
    scheduleId: scheduleId,
    selectedOption: option,
    recurrenceRule: rule,
  );

  Reply reply(
    String memberId,
    String scheduleId,
    DateTime instanceDate,
    ReplyOptions option,
  ) => Reply(
    memberId: memberId,
    scheduleId: scheduleId,
    instanceDate: instanceDate,
    selectedOption: option,
  );

  group('getScheduleInstances — instance expansion', () {
    test('daily schedule yields one instance per day, [after, before)', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(7), // Mon..next Mon
      );

      // Window end is exclusive: Mon (day 0) .. Sun (day 6) == 7 instances.
      expect(result.map((e) => e.instanceDate), [
        day(0),
        day(1),
        day(2),
        day(3),
        day(4),
        day(5),
        day(6),
      ]);
    });

    test('`once` schedule yields exactly one instance', () {
      final s = schedule(CommonRecurrenceRules.once);
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(30),
      );
      expect(result, hasLength(1));
      expect(result.single.instanceDate, day(0));
    });

    test('weekends rule yields only Saturday and Sunday in the first week', () {
      final s = schedule(CommonRecurrenceRules.weekends);
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(7),
      );
      // Sat == day(5), Sun == day(6).
      expect(result.map((e) => e.instanceDate), [day(5), day(6)]);
    });

    test('weekly rule yields one instance per week on the start weekday', () {
      final s = schedule(CommonRecurrenceRules.weekly);
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(21), // 3 weeks, exclusive end
      );
      expect(result.map((e) => e.instanceDate), [day(0), day(7), day(14)]);
    });

    test(
      'expansion starts at schedule.startDate when the window opens earlier',
      () {
        // Schedule starts a week after the requested window start.
        final s = schedule(CommonRecurrenceRules.daily, start: day(7));
        final result = getScheduleInstances(
          schedule: s,
          members: [member(memberA)],
          startDate: monday, // earlier than schedule.startDate
          endDate: day(10),
        );
        // Instances cannot precede schedule.startDate (day 7).
        expect(result.map((e) => e.instanceDate), [day(7), day(8), day(9)]);
      },
    );
  });

  group('repliesForScheduleInstance — reply/default resolution', () {
    test('a matching default rule contributes its reply to yesCount', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0),
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA)],
        defaultRules: [
          defaultRule(
            memberA,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
      );

      expect(summary.yesCount, 1);
      expect(summary.memberDefaultReplies[memberA], ReplyOptions.yes);
      // memberDefaultRules holds the rule for the schedule regardless of the day.
      expect(summary.memberDefaultRules.containsKey(memberA), isTrue);
      // No explicit reply was given.
      expect(summary.memberReplies, isEmpty);
    });

    test('an explicit reply overrides the default rule for that day', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0),
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA)],
        defaultRules: [
          defaultRule(
            memberA,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
        replies: [reply(memberA, s.id, day(0), ReplyOptions.no)],
      );

      // Reply 'no' overrides default 'yes' → not counted.
      expect(summary.yesCount, 0);
      expect(summary.memberReplies[memberA], ReplyOptions.no);
      expect(summary.memberDefaultReplies[memberA], ReplyOptions.yes);
    });

    test('a default rule only applies on days its own recurrence matches', () {
      // Daily schedule, but memberB defaults to yes ONLY on weekends.
      final s = schedule(CommonRecurrenceRules.daily);
      final rules = [
        defaultRule(
          memberB,
          s.id,
          ReplyOptions.yes,
          CommonRecurrenceRules.weekends,
        ),
      ];
      final members = [member(memberB)];

      final weekday = repliesForScheduleInstance(
        instanceDate: day(0), // Monday
        schedule: s,
        startDate: monday,
        endDate: day(7),
        members: members,
        defaultRules: rules,
      );
      final weekend = repliesForScheduleInstance(
        instanceDate: day(5), // Saturday
        schedule: s,
        startDate: monday,
        endDate: day(7),
        members: members,
        defaultRules: rules,
      );

      expect(weekday.yesCount, 0, reason: 'weekend rule does not match Monday');
      expect(weekday.memberDefaultReplies.containsKey(memberB), isFalse);
      expect(weekend.yesCount, 1, reason: 'weekend rule matches Saturday');
      expect(weekend.memberDefaultReplies[memberB], ReplyOptions.yes);
    });

    test('replies and defaults for non-members are ignored', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0),
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA)], // memberC is not here
        defaultRules: [
          defaultRule(
            memberC,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
        replies: [reply(memberC, s.id, day(0), ReplyOptions.yes)],
      );

      expect(summary.yesCount, 0);
      expect(summary.memberReplies, isEmpty);
      expect(summary.memberDefaultReplies, isEmpty);
    });

    test('targetMemberId separates "my" view from other members', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0),
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA), member(memberB)],
        targetMemberId: memberA,
        defaultRules: [
          defaultRule(
            memberA,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
          defaultRule(
            memberB,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
        replies: [reply(memberA, s.id, day(0), ReplyOptions.no)],
      );

      // "My" data is pulled out of the per-member maps.
      expect(summary.myReply, ReplyOptions.no);
      expect(summary.myDefaultReply, ReplyOptions.yes);
      expect(summary.myDefaultRule, isNotNull);
      expect(summary.memberReplies.containsKey(memberA), isFalse);
      expect(summary.memberDefaultReplies.containsKey(memberA), isFalse);
      // The other member is still tracked.
      expect(summary.memberDefaultReplies[memberB], ReplyOptions.yes);
      // yesCount spans everyone: memberA replied 'no' (0) + memberB default 'yes' (1).
      expect(summary.yesCount, 1);
    });

    test('yesCount aggregates yes across all members for the instance', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0),
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA), member(memberB)],
        defaultRules: [
          defaultRule(
            memberA,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
        replies: [reply(memberB, s.id, day(0), ReplyOptions.yes)],
      );
      expect(summary.yesCount, 2);
    });
  });

  group('clock-time semantics — the copyWith(isUtc: true) reinterpretation', () {
    // Reply/default-rule dates are matched to instances via
    // `copyWith(isUtc: true).isAtSameMomentAs(instanceDate)` — a WALL-CLOCK
    // relabeling, not an epoch conversion. These tests pin that semantic; it is
    // exactly the hack a refactor (or the repository `toUtc()` inconsistency
    // fix) could silently change.

    test('a local-time (non-UTC) reply matches by wall-clock relabeling', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0), // 2024-01-01T00:00Z
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA)],
        // Local midnight: a DIFFERENT moment than UTC midnight on any machine
        // not running in UTC — but the relabeling makes it match regardless.
        replies: [reply(memberA, s.id, DateTime(2024, 1, 1), ReplyOptions.yes)],
      );

      expect(summary.memberReplies[memberA], ReplyOptions.yes);
      expect(summary.yesCount, 1);
    });

    test('matching is by exact moment, not by day', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final summary = repliesForScheduleInstance(
        instanceDate: day(0), // midnight
        schedule: s,
        startDate: monday,
        endDate: day(1),
        members: [member(memberA)],
        // Same day, 01:00 — does NOT match the midnight instance.
        replies: [
          reply(memberA, s.id, DateTime.utc(2024, 1, 1, 1), ReplyOptions.yes),
        ],
      );

      expect(summary.memberReplies, isEmpty);
      expect(summary.yesCount, 0);
    });

    test('instances inherit the startDate time-of-day', () {
      // A schedule created at 10:00 produces 10:00 instances, and a midnight
      // reply for the same calendar day is IGNORED. This is the sharp edge of
      // moment-based matching once startDate carries a time-of-day.
      final s = schedule(
        CommonRecurrenceRules.daily,
        start: DateTime.utc(2024, 1, 1, 10),
      );
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(3),
        replies: [reply(memberA, s.id, day(1), ReplyOptions.yes)],
      ).toList();

      // All 10:00 instances before the exclusive window end (day 3 midnight).
      expect(result.map((e) => e.instanceDate), [
        DateTime.utc(2024, 1, 1, 10),
        DateTime.utc(2024, 1, 2, 10),
        DateTime.utc(2024, 1, 3, 10),
      ]);
      // The midnight reply matched no 10:00 instance.
      expect(result.every((e) => e.memberReplies.isEmpty), isTrue);
    });
  });

  group('rrule edges — month boundaries, UNTIL, interval', () {
    test('monthly on the 31st skips months without a 31st', () {
      final s = schedule(
        CommonRecurrenceRules.monthly,
        start: DateTime.utc(2024, 1, 31),
      );
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: DateTime.utc(2024, 1, 1),
        endDate: DateTime.utc(2024, 6, 1),
      );
      // Feb (29 days) and Apr (30 days) have no 31st and are skipped.
      expect(result.map((e) => e.instanceDate), [
        DateTime.utc(2024, 1, 31),
        DateTime.utc(2024, 3, 31),
        DateTime.utc(2024, 5, 31),
      ]);
    });

    test('monthly on the 29th includes leap-year Feb 29', () {
      final s = schedule(
        CommonRecurrenceRules.monthly,
        start: DateTime.utc(2024, 1, 29),
      );
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: DateTime.utc(2024, 1, 1),
        endDate: DateTime.utc(2024, 4, 1),
      );
      expect(result.map((e) => e.instanceDate), [
        DateTime.utc(2024, 1, 29),
        DateTime.utc(2024, 2, 29), // 2024 is a leap year
        DateTime.utc(2024, 3, 29),
      ]);
    });

    test('UNTIL bounds the expansion (inclusive)', () {
      final s = schedule(
        RecurrenceRule(frequency: Frequency.daily, until: day(3)),
      );
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(30), // window is wider than UNTIL
      );
      expect(result.map((e) => e.instanceDate), [
        day(0),
        day(1),
        day(2),
        day(3), // UNTIL is inclusive
      ]);
    });

    test('interval > 1 expands every Nth period', () {
      final s = schedule(
        RecurrenceRule(frequency: Frequency.weekly, interval: 2),
      );
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(35), // 5 weeks
      );
      expect(result.map((e) => e.instanceDate), [day(0), day(14), day(28)]);
    });
  });

  group('end-to-end via getScheduleInstances', () {
    test('default yes every day, with a single "no" override on one day', () {
      final s = schedule(CommonRecurrenceRules.daily);
      final result = getScheduleInstances(
        schedule: s,
        members: [member(memberA)],
        startDate: monday,
        endDate: day(7),
        targetMemberId: memberA,
        defaultRules: [
          defaultRule(
            memberA,
            s.id,
            ReplyOptions.yes,
            CommonRecurrenceRules.daily,
          ),
        ],
        replies: [reply(memberA, s.id, day(2), ReplyOptions.no)],
      ).toList();

      expect(result, hasLength(7));
      final overridden = result.firstWhere((e) => e.instanceDate == day(2));
      expect(overridden.myReply, ReplyOptions.no);
      expect(overridden.yesCount, 0);

      for (final other in result.where((e) => e.instanceDate != day(2))) {
        expect(other.myReply, isNull, reason: 'no explicit reply that day');
        expect(other.myDefaultReply, ReplyOptions.yes);
        expect(other.yesCount, 1);
      }
    });
  });
}
