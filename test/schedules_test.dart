import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/schedules.dart';
import 'package:parousia/util/util.dart';
import 'package:test/test.dart';

DateTime _findSunday(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

void main() {
  group('schedules instances', () {
    test('basic setup with default replies and overrides', () {
      const testDays = 10;
      final startDate = DateTime(2000, 1, 1).toUtc();
      final endDate = startDate.add(const Duration(days: testDays));

      final dailyRecurrenceRule = CommonRecurrenceRules.daily;
      final dailySchedule = Schedule(
          id: 1,
          groupId: 1,
          displayName: 'Daily schedule',
          startDate: startDate,
          recurrenceRule: dailyRecurrenceRule);
      final weekendRecurrenceRule = CommonRecurrenceRules.weekends;
      final weekendSchedule = Schedule(
          id: 2,
          groupId: 1,
          displayName: 'Weekend schedule',
          startDate: startDate,
          recurrenceRule: weekendRecurrenceRule);

      final defaultReplies = [
        DefaultReply(
            memberId: 32,
            scheduleId: dailySchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: dailyRecurrenceRule),
        DefaultReply(
            memberId: 32,
            scheduleId: weekendSchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
        DefaultReply(
            memberId: 33,
            scheduleId: dailySchedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
      ];

      // find next sunday (avoid today, start searching from tomorrow)
      final sunday = _findSunday(startDate.add(const Duration(days: 1)));
      final saturday = sunday.add(const Duration(days: -1));
      final replies = [
        Reply(
            memberId: 32,
            scheduleId: dailySchedule.id,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: 33,
            scheduleId: dailySchedule.id,
            instanceDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: 32,
            scheduleId: dailySchedule.id,
            instanceDate: saturday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: 32,
            scheduleId: weekendSchedule.id,
            instanceDate: sunday,
            selectedOption: ReplyOptions.yes),
      ];

      final result = getScheduleInstances(
        schedule: dailySchedule,
        defaultReplies: defaultReplies,
        replies: replies,
        startDate: startDate.subtract(const Duration(days: 10)),
        endDate: endDate,
        targetMemberId: 32,
      );

      expect(result, isNotNull);
      expect(result, hasLength(testDays));

      final sundayInstance =
          result.singleWhere((element) => element.instanceDate == sunday);
      expect(sundayInstance.myReply, ReplyOptions.no);
      expect(sundayInstance.yesCount, 0);

      final saturdayInstance =
          result.singleWhere((element) => element.instanceDate == saturday);
      expect(saturdayInstance.myReply, ReplyOptions.no);
      expect(saturdayInstance.yesCount, 1);
    });
  });
}
