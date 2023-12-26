import 'package:parousia/models/models.dart';
import 'package:parousia/selectors/schedules.dart';
import 'package:parousia/util/util.dart';
import 'package:test/test.dart';

DateTime _findSunday(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

void main() {
  group('schedules instances', () {
    test('something', () {
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
            id: 128,
            memberId: 32,
            scheduleId: schedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: dailyRecurrenceRule),
        DefaultReply(
            id: 129,
            memberId: 33,
            scheduleId: schedule.id,
            selectedOption: ReplyOptions.yes,
            recurrenceRule: weekendRecurrenceRule),
      ];

      final sunday = _findSunday(startDate);
      final saturday = sunday.add(const Duration(days: -1));
      final replies = [
        Reply(
            id: 128,
            memberId: 32,
            scheduleId: schedule.id,
            eventDate: sunday,
            selectedOption: ReplyOptions.no),
        Reply(
            id: 129,
            memberId: 33,
            scheduleId: schedule.id,
            eventDate: sunday,
            selectedOption: ReplyOptions.no),
      ];

      final result = getScheduleInstances(
        schedule: schedule,
        defaultReplies: defaultReplies,
        replies: replies,
        startDate: startDate,
        endDate: endDate,
        targetUserId: 32,
      );

      expect(result, isNotNull);
      expect(result, hasLength(testDays));
    });
  });
}
