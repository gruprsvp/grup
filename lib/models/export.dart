import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:parousia/util/datetime.dart';

import 'default_reply.dart';
import 'member.dart';
import 'reply.dart';
import 'rsvp.dart';
import 'schedule.dart';

/// Everyone's answer to every occurrence of [schedules] from [first] to
/// [last] (days, both included), as CSV: one row per occurrence and member
/// (export_csv). Each day is resolved as the group's page shows it.
String answersCsv({
  required DateTime first,
  required DateTime last,
  required List<Schedule> schedules,
  required List<Member> members,
  required String Function(Member member) nameOf,
  required List<DefaultRule> defaultRules,
  required List<Reply> replies,
}) {
  final date = DateFormat('yyyy-MM-dd');
  final time = DateFormat('HH:mm');
  final byName = [
    ...members,
  ]..sort((a, b) => nameOf(a).toLowerCase().compareTo(nameOf(b).toLowerCase()));
  // Resolution only reads a schedule's own rules and replies: handing it
  // just those makes a year's export several times faster.
  final rulesOf = defaultRules.groupListsBy((rule) => rule.scheduleId);
  final repliesOf = replies.groupListsBy((reply) => reply.scheduleId);
  final rows = [
    ['date', 'time', 'event', 'name', 'managed', 'answer', 'source', 'late'],
  ];
  for (
    var day = DateTime(first.year, first.month, first.day);
    !day.isAfter(last);
    day = day.copyWith(day: day.day + 1)
  ) {
    final range = day.getDayRange();
    final occurrences = [
      for (final schedule in schedules)
        if (!schedule.startDate.isAfter(range.end))
          for (final instance in getScheduleInstances(
            schedule: schedule,
            startDate: range.start,
            endDate: range.end,
            members: members,
            defaultRules: rulesOf[schedule.id] ?? const [],
            replies: repliesOf[schedule.id] ?? const [],
          ))
            (schedule, instance),
    ]..sort((a, b) => a.$2.instanceDate.compareTo(b.$2.instanceDate));
    for (final (schedule, instance) in occurrences) {
      final late = lateMemberIds(
        schedule,
        instance,
        repliesOf[schedule.id] ?? const [],
      );
      for (final member in byName) {
        final reply = instance.memberReplies[member.id];
        final usual = instance.memberDefaultReplies[member.id];
        rows.add([
          // Occurrences carry the wall-clock time in UTC fields.
          date.format(instance.instanceDate),
          time.format(instance.instanceDate),
          schedule.displayName,
          nameOf(member),
          member.profileId == null ? 'yes' : 'no',
          (reply ?? usual)?.name ?? '',
          reply != null ? 'reply' : (usual != null ? 'default' : 'none'),
          late.contains(member.id) ? 'yes' : 'no',
        ]);
      }
    }
  }
  return '${rows.map((row) => row.map(_field).join(',')).join('\r\n')}\r\n';
}

/// A CSV field (RFC 4180). Names are typed by users: a leading = + - @
/// would make a spreadsheet run them as a formula, so those are kept text.
String _field(String value) {
  final text = value.startsWith(RegExp(r'[=+\-@\t\r]')) ? "'$value" : value;
  return text.contains(RegExp(r'[",\r\n]'))
      ? '"${text.replaceAll('"', '""')}"'
      : text;
}
