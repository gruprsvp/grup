import 'package:parousia/brick/brick.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/util/util.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

DateTime _findSunday(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

void main() {
  group('schedules instances', () {
    test('basic setup with default replies and overrides', () {
      const testDays = 10;
      final startDate = DateTime(2000, 1, 1);
      final endDate = startDate.add(const Duration(days: testDays));

      final dailyScheduleId = const Uuid().v7();
      final weekendScheduleId = const Uuid().v7();
      final member1Id = const Uuid().v7();
      final member2Id = const Uuid().v7();
      final groupId = const Uuid().v7();

      final group = Group(id: groupId, displayName: 'Group');
      final member1 = Member(
        id: member1Id,
        group: group,
        role: GroupRoles.admin,
      );
      final member2 = Member(
        id: member2Id,
        group: group,
        role: GroupRoles.admin,
      );

      final dailyRecurrenceRule = CommonRecurrenceRules.daily;
      final dailySchedule = Schedule(
          id: dailyScheduleId,
          group: group,
          displayName: 'Daily schedule',
          startDate: startDate,
          recurrenceRule: dailyRecurrenceRule,
          timezone: 'Europe/Zurich');
      final weekendRecurrenceRule = CommonRecurrenceRules.weekends;
      final weekendSchedule = Schedule(
          id: weekendScheduleId,
          group: group,
          displayName: 'Weekend schedule',
          startDate: startDate,
          recurrenceRule: weekendRecurrenceRule,
          timezone: 'Europe/Zurich');

      final defaultRules = [
        DefaultRule(
            member: member1,
            schedule: dailySchedule,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: dailyRecurrenceRule),
        DefaultRule(
            member: member1,
            schedule: weekendSchedule,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
        DefaultRule(
            member: member2,
            schedule: dailySchedule,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
      ];

      // find next sunday (avoid today, start searching from tomorrow)
      final sunday = _findSunday(startDate.add(const Duration(days: 1)));
      final saturday = sunday.add(const Duration(days: -1));
      final replies = [
        Reply(
            member: member1,
            schedule: dailySchedule,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            member: member2,
            schedule: dailySchedule,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            member: member1,
            schedule: dailySchedule,
            instanceDate: saturday,
            selectedOption: ReplyOptions.no),
        Reply(
            member: member1,
            schedule: weekendSchedule,
            instanceDate: sunday,
            selectedOption: ReplyOptions.yes),
      ];

      final members = [
        Member(id: member1Id, groupId: groupId, role: GroupRoles.member),
        Member(id: member2Id, groupId: groupId, role: GroupRoles.member),
      ];

      final result = getScheduleInstances(
        schedule: dailySchedule,
        defaultRules: defaultRules,
        replies: replies,
        members: members,
        startDate: startDate.subtract(const Duration(days: 10)),
        endDate: endDate,
        targetMemberId: member1Id,
      );

      expect(result, isNotNull);
      expect(result, hasLength(testDays));

      final sundayInstance =
          result.singleWhere((element) => element.instanceDate == sunday);
      expect(sundayInstance.myReply?.selectedOption, ReplyOptions.no);
      expect(sundayInstance.yesCount, 0);

      final saturdayInstance =
          result.singleWhere((element) => element.instanceDate == saturday);
      expect(saturdayInstance.myReply?.selectedOption, ReplyOptions.no);
      expect(saturdayInstance.yesCount, 1);
    });
  });
}
