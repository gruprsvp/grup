import 'package:parousia/models/models.dart';
import 'package:redux_entity/redux_entity.dart';

final profilesReducer =
    RemoteEntityReducer<RemoteEntityState<Profile>, Profile>();

final groupsReducer = RemoteEntityReducer<RemoteEntityState<Group>, Group>(
  selectId: (group) => group.id.toString(),
);

final membersReducer = RemoteEntityReducer<RemoteEntityState<Member>, Member>(
  selectId: (member) => member.id.toString(),
);

final invitesReducer = RemoteEntityReducer<RemoteEntityState<Invite>, Invite>(
  selectId: (invite) => invite.id.toString(),
);

final schedulesReducer =
    RemoteEntityReducer<RemoteEntityState<Schedule>, Schedule>(
  selectId: (schedule) => schedule.id.toString(),
);

final defaultRulesReducer =
    RemoteEntityReducer<RemoteEntityState<DefaultRule>, DefaultRule>(
  selectId: (defaultRule) =>
      "${defaultRule.memberId}-${defaultRule.scheduleId}",
);

final repliesReducer = RemoteEntityReducer<RemoteEntityState<Reply>, Reply>(
  selectId: (reply) =>
      "${reply.memberId}-${reply.scheduleId}-${reply.instanceDate}",
);
