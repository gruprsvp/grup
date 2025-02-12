import 'package:parousia/brick/brick.dart';
import 'package:parousia/reducers/remote_entities.dart';
import 'package:parousia/util/util.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:test/test.dart';

import 'remote_entity_reducer_tester.dart';

void main() {
  group(profilesReducer, () {
    generator() => Fake.profile();

    final tester = RemoteEntityReducerTester<
        RemoteEntityReducer<RemoteEntityState<Profile>, Profile>,
        RemoteEntityState<Profile>,
        Profile>();

    return tester.testAll(
        profilesReducer, generator, const RemoteEntityState<Profile>());
  });

  group(groupsReducer, () {
    generator() => Fake.group();

    final tester = RemoteEntityReducerTester<
        RemoteEntityReducer<RemoteEntityState<Group>, Group>,
        RemoteEntityState<Group>,
        Group>();

    return tester.testAll(
        groupsReducer, generator, const RemoteEntityState<Group>());
  });

  group(schedulesReducer, () {
    generator() => Fake.schedule();

    final tester = RemoteEntityReducerTester<
        RemoteEntityReducer<RemoteEntityState<Schedule>, Schedule>,
        RemoteEntityState<Schedule>,
        Schedule>();

    return tester.testAll(
        schedulesReducer, generator, const RemoteEntityState<Schedule>());
  });

  // TODO tests for nested entities
}
