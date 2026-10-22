import 'package:flutter/foundation.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

/// A group's events on one day, with everyone's answers.
class GroupDetailsViewModel extends ChangeNotifier {
  GroupDetailsViewModel({
    required this.groupId,
    required this._groups,
    required this._schedules,
    DateTime? date,
  }) : _date = date ?? DateTime.now() {
    load = Command0(_load)..execute();
    _groups.addListener(_update);
    _schedules.addListener(_update);
    _update();
  }

  final String groupId;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;

  DateTime _date;
  List<ScheduleInstanceSummary> _instances = const [];

  /// Fetches the group, and its events around [date].
  late final Command0<void> load;

  Group? get group => _groups.group(groupId);

  bool get isAdmin => _groups.ownMember(groupId)?.role == GroupRoles.admin;

  DateTime get date => _date;

  /// The occurrences on [date], earliest first. Computed when the data or the
  /// date changes, not on every build.
  List<ScheduleInstanceSummary> get instances => _instances;

  void selectDate(DateTime date) {
    _date = date;
    _update();
    // A running load picks the new date up when it finishes (see _load).
    load.execute();
  }

  /// Answers [instance] for the user, or clears their answer when [option]
  /// is null.
  ///
  /// Not a [Command]: a command ignores a second tap while the first is
  /// running, and the user may answer several events in quick succession.
  /// The answer shows at once; the result says whether it was saved.
  Future<Result<void>> reply(
    ScheduleInstanceSummary instance,
    ReplyOptions? option,
  ) {
    final memberId = instance.targetMemberId;
    if (memberId == null) {
      return Future.value(const Result.error(NotAllowedException()));
    }
    return _schedules.reply(
      memberId: memberId,
      scheduleId: instance.scheduleId,
      instanceDate: instance.instanceDate,
      option: option,
    );
  }

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _loadSchedules(),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  /// Loads the replies around [date], again if the date changed meanwhile.
  Future<Result<void>> _loadSchedules() async {
    while (true) {
      final date = _date;
      final result = await _schedules.load(groupId, date.getNdayRange(1));
      if (date == _date) return result;
    }
  }

  void _update() {
    final range = _date.getDayRange();
    final members = _groups.members(groupId);
    final targetMemberId = _groups.ownMember(groupId)?.id;
    final defaultRules = _schedules.defaultRules(groupId);
    final replies = _schedules.replies(groupId);
    _instances = [
      for (final schedule in _schedules.schedules(groupId))
        // Schedules that start later have no occurrence on this day.
        if (!schedule.startDate.isAfter(range.end))
          ...getScheduleInstances(
            schedule: schedule,
            startDate: range.start,
            endDate: range.end,
            members: members,
            defaultRules: defaultRules,
            replies: replies,
            targetMemberId: targetMemberId,
          ),
    ]..sort((a, b) => a.instanceDate.compareTo(b.instanceDate));
    notifyListeners();
  }

  @override
  void dispose() {
    _groups.removeListener(_update);
    _schedules.removeListener(_update);
    super.dispose();
  }
}
