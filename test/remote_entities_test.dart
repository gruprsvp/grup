import 'package:parousia/models/models.dart';
import 'package:parousia/reducers/remote_entities.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'remote_entity_reducer_tester.dart';
import 'support/fake_data.dart';

void main() {
  group(profilesReducer, () {
    generator() => FakeData.profile();

    final tester =
        RemoteEntityReducerTester<
          RemoteEntityReducer<RemoteEntityState<Profile>, Profile>,
          RemoteEntityState<Profile>,
          Profile
        >();

    return tester.testAll(
      profilesReducer,
      generator,
      const RemoteEntityState<Profile>(),
    );
  });

  group(groupsReducer, () {
    generator() => FakeData.group();

    final tester =
        RemoteEntityReducerTester<
          RemoteEntityReducer<RemoteEntityState<Group>, Group>,
          RemoteEntityState<Group>,
          Group
        >();

    return tester.testAll(
      groupsReducer,
      generator,
      const RemoteEntityState<Group>(),
    );
  });

  group(schedulesReducer, () {
    generator() => FakeData.schedule();

    final tester =
        RemoteEntityReducerTester<
          RemoteEntityReducer<RemoteEntityState<Schedule>, Schedule>,
          RemoteEntityState<Schedule>,
          Schedule
        >();

    return tester.testAll(
      schedulesReducer,
      generator,
      const RemoteEntityState<Schedule>(),
    );
  });

  // TODO tests for nested entities
}
