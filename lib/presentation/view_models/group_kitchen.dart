import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import 'view_model.dart';

/// One event of the kitchen's day: how many are coming, who, and who
/// changed their answer late.
typedef KitchenEvent = ({
  Schedule schedule,
  ScheduleInstanceSummary instance,

  /// Who's coming, by name, with their profile once they joined.
  List<(Member, Profile?)> coming,

  /// Of those coming, how many have an account, and how many the admins
  /// manage.
  int members,
  int guests,
  int no,
  int noReply,

  /// Who changed their answer after changes closed (reply_cutoffs).
  List<(Member, Profile?)> late,
});

/// A day of a group's events as the kitchen needs it (kitchen_view). Worked
/// out from what the group's pages already load: members can read it all.
class GroupKitchenViewModel extends ViewModel {
  GroupKitchenViewModel({
    required this.groupId,
    required this._groups,
    required this._schedules,
    required this._billing,
    DateTime? date,
  }) : _date = date ?? DateTime.now() {
    load = Command0(_load)..execute();
    listenTo([_groups, _schedules, _billing], _update);
    listenTo([load]);
    _update();
  }

  final String groupId;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;
  final BillingRepository _billing;

  DateTime _date;
  List<KitchenEvent> _events = const [];

  late final Command0<void> load;

  Group? get group => _groups.group(groupId);

  GroupAccess get access => _billing.access(groupId);

  DateTime get date => _date;

  /// The day's events, earliest first.
  List<KitchenEvent> get events => _events;

  void selectDate(DateTime date) {
    _date = date;
    _update();
    load.execute();
  }

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _schedules.load(groupId, _date.getNdayRange(1)),
      _billing.refresh(),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }

  void _update() {
    final range = _date.getDayRange();
    final members = _groups.members(groupId);
    final defaultRules = _schedules.defaultRules(groupId);
    final replies = _schedules.replies(groupId);
    final cutoffs = access.can(FeatureKey.replyCutoffs);
    (Member, Profile?) withProfile(Member member) =>
        (member, _groups.profile(member.profileId));
    // By name, as a kitchen reads a list.
    String nameOf(Member member) =>
        (member.displayNameOverride ??
                _groups.profile(member.profileId)?.displayName ??
                '')
            .toLowerCase();
    final byName = [...members]..sort((a, b) => nameOf(a).compareTo(nameOf(b)));
    _events =
        [
          for (final schedule in _schedules.schedules(groupId))
            if (!schedule.startDate.isAfter(range.end))
              for (final instance in getScheduleInstances(
                schedule: schedule,
                startDate: range.start,
                endDate: range.end,
                members: members,
                defaultRules: defaultRules,
                replies: replies,
              ))
                _event(
                  schedule,
                  instance,
                  byName,
                  withProfile,
                  late: cutoffs
                      ? lateMemberIds(schedule, instance, replies)
                      : const {},
                ),
        ]..sort(
          (a, b) => a.instance.instanceDate.compareTo(b.instance.instanceDate),
        );
    notifyListeners();
  }

  static KitchenEvent _event(
    Schedule schedule,
    ScheduleInstanceSummary instance,
    List<Member> members,
    (Member, Profile?) Function(Member) withProfile, {
    required Set<String> late,
  }) {
    ReplyOptions? answer(Member member) =>
        instance.memberReplies[member.id] ??
        instance.memberDefaultReplies[member.id];
    final coming = members
        .where((member) => answer(member) == ReplyOptions.yes)
        .toList();
    return (
      schedule: schedule,
      instance: instance,
      coming: coming.map(withProfile).toList(),
      members: coming.where((member) => member.profileId != null).length,
      guests: coming.where((member) => member.profileId == null).length,
      no: members.where((member) => answer(member) == ReplyOptions.no).length,
      noReply: members.where((member) => answer(member) == null).length,
      late: members
          .where((member) => late.contains(member.id))
          .map(withProfile)
          .toList(),
    );
  }
}
