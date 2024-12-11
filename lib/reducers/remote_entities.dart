import 'package:parousia/brick/brick.dart';
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

final defaultRepliesReducer =
    RemoteEntityReducer<RemoteEntityState<DefaultReply>, DefaultReply>(
  selectId: (defaultReply) =>
      "${defaultReply.member.id}-${defaultReply.schedule.id}",
);

final repliesReducer = RemoteEntityReducer<RemoteEntityState<Reply>, Reply>(
  selectId: (reply) =>
      "${reply.member.id}-${reply.schedule.id}-${reply.instanceDate}",
);
