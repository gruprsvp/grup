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
      final startDate = DateTime.now().getDayStart();
      final endDate = startDate.add(const Duration(days: testDays));

      final recurrenceRule = CommonRecurrenceRules.daily;
      final schedule = Schedule(
          id: 2,
          groupId: 1,
          displayName: 'Test schedule',
          startDate: startDate,
          recurrenceRule: recurrenceRule);

      final dailyRecurrenceRule = CommonRecurrenceRules.daily;
      final weekendRecurrenceRule = CommonRecurrenceRules.weekends;
      final defaultReplies = [
        DefaultReply(
            memberId: 32,
            scheduleId: schedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: dailyRecurrenceRule),
        DefaultReply(
            memberId: 33,
            scheduleId: schedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
      ];

      // find next sunday (avoid today, start searching from tomorrow)
      final sunday = _findSunday(startDate.add(const Duration(days: 1)));
      final saturday = sunday.add(const Duration(days: -1));
      final replies = [
        Reply(
            memberId: 32,
            scheduleId: schedule.id,
            eventDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: 33,
            scheduleId: schedule.id,
            eventDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            memberId: 32,
            scheduleId: schedule.id,
            eventDate: saturday,
            selectedOption: ReplyOptions.no),
      ];

      final result = getScheduleInstances(
        schedule: schedule,
        defaultReplies: defaultReplies,
        replies: replies,
        startDate: startDate,
        endDate: endDate,
        targetMemberId: 32,
      );

      expect(result, isNotNull);
      expect(result, hasLength(testDays));

      final sundayInstance =
          result.singleWhere((element) => element.eventDate == sunday);
      expect(sundayInstance.myReply, ReplyOptions.no);
      expect(sundayInstance.yesCount, 0);

      final saturdayInstance =
          result.singleWhere((element) => element.eventDate == saturday);
      expect(saturdayInstance.myReply, ReplyOptions.no);
      expect(saturdayInstance.yesCount, 1);
    });
  });
}
