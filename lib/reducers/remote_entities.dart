import 'package:parousia/models/models.dart';
import 'package:redux_entity/redux_entity.dart';

final profilesReducer =
    RemoteEntityReducer<RemoteEntityState<Profile>, Profile>();

final groupsReducer = RemoteEntityReducer<RemoteEntityState<Group>, Group>(
  selectId: (group) => group.id.toString(),
);

final schedulesReducer =
    RemoteEntityReducer<RemoteEntityState<Schedule>, Schedule>(
  selectId: (schedule) => schedule.id.toString(),
);

final defaultRepliesReducer =
    RemoteEntityReducer<RemoteEntityState<DefaultReply>, DefaultReply>(
  selectId: (defaultReply) =>
      "${defaultReply.memberId}-${defaultReply.scheduleId}",
);

final repliesReducer = RemoteEntityReducer<RemoteEntityState<Reply>, Reply>(
  selectId: (reply) =>
      "${reply.memberId}-${reply.scheduleId}-${reply.eventDate}",
);
