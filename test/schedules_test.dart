import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/selectors.dart';
import 'package:parousia/util/util.dart';
import 'package:test/test.dart';
import 'package:timezone/data/latest.dart';
import 'package:uuid/uuid.dart';

DateTime _findSunday(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

void main() {
  group('schedules instances', () {
    test('basic setup with default replies and overrides', () {
      initializeTimeZones();

      const testDays = 10;
      final startDate = DateTime(2000, 1, 1).toUtc();
      final endDate = startDate.add(const Duration(days: testDays));

      final dailyScheduleId = const Uuid().v7();
      final weekendScheduleId = const Uuid().v7();
      final member1Id = const Uuid().v7();
      final member2Id = const Uuid().v7();
      final groupId = const Uuid().v7();

      final dailyRecurrenceRule = CommonRecurrenceRules.daily;
      final dailySchedule = Schedule(
          id: dailyScheduleId,
          groupId: 'group',
          displayName: 'Daily schedule',
          startDate: startDate,
          recurrenceRule: dailyRecurrenceRule,
          timezone: 'Europe/Zurich');
      final weekendRecurrenceRule = CommonRecurrenceRules.weekends;
      final weekendSchedule = Schedule(
          id: weekendScheduleId,
          groupId: groupId,
          displayName: 'Weekend schedule',
          startDate: startDate,
          recurrenceRule: weekendRecurrenceRule,
          timezone: 'Europe/Zurich');

      final defaultRules = [
        DefaultRule(
            memberId: member1Id,
            scheduleId: dailySchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: dailyRecurrenceRule),
        DefaultRule(
            memberId: member1Id,
            scheduleId: weekendSchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
        DefaultRule(
            memberId: member2Id,
            scheduleId: dailySchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
      ];

      // find next sunday (avoid today, start searching from tomorrow)
      final sunday = _findSunday(startDate.add(const Duration(days: 1)));
      final saturday = sunday.add(const Duration(days: -1));
      final replies = [
        Reply(
            memberId: member1Id,
            scheduleId: dailySchedule.id,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: member2Id,
            scheduleId: dailySchedule.id,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: member1Id,
            scheduleId: dailySchedule.id,
            instanceDate: saturday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: member1Id,
            scheduleId: weekendSchedule.id,
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

      final sundayInstance = result.singleWhere(
          (element) => element.instanceDate.copyWith(isUtc: true) == sunday);
      expect(sundayInstance.myReply, ReplyOptions.no);
      expect(sundayInstance.yesCount, 0);

      final saturdayInstance = result.singleWhere(
          (element) => element.instanceDate.copyWith(isUtc: true) == saturday);
      expect(saturdayInstance.myReply, ReplyOptions.no);
      expect(saturdayInstance.yesCount, 1);
    });
  });
}
