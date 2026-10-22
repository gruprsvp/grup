import 'package:image_picker/image_picker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/repositories/repositories.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/result.dart';
import 'package:parousia/util/util.dart';

import 'view_model.dart';

/// What an admin manages in a group: its members, events and details.
class GroupManageViewModel extends ViewModel {
  GroupManageViewModel({
    required this.groupId,
    required this._groups,
    required this._schedules,
  }) {
    load = Command0(_load)..execute();
    update = Command1((args) => _groups.update(args.group, image: args.image));
    delete = Command0(() => _groups.delete(groupId));
    invite = Command1((contacts) => _groups.invite(groupId, contacts));
    createSchedule = Command1(
      (schedule) => _schedules.create(schedule.copyWith(groupId: groupId)),
    );
    deleteSchedule = Command1(_schedules.delete);
    listenTo([
      _groups,
      _schedules,
      load,
      update,
      delete,
      invite,
      createSchedule,
      deleteSchedule,
    ]);
  }

  final String groupId;
  final GroupsRepository _groups;
  final SchedulesRepository _schedules;

  late final Command0<void> load;
  late final Command1<Group, ({Group group, XFile? image})> update;
  late final Command0<void> delete;
  late final Command1<void, List<ContactInvite>> invite;
  late final Command1<Schedule, Schedule> createSchedule;
  late final Command1<void, Schedule> deleteSchedule;

  Group? get group => _groups.group(groupId);

  /// The members, newest first, with their profiles once they joined.
  List<(Member, Profile?)> get members => [
    for (final member in _groups.members(groupId))
      (member, _groups.profile(member.profileId)),
  ];

  List<Schedule> get schedules => _schedules.schedules(groupId);

  Future<Result<void>> _load() async {
    final results = await Future.wait([
      _groups.refreshGroup(groupId),
      _schedules.load(groupId, DateTime.now().getNdayRange(1)),
    ]);
    return results.firstWhere(
      (result) => result is Error,
      orElse: () => const Result.ok(null),
    );
  }
}
