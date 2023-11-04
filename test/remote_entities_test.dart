import 'dart:math';

import 'package:parousia/models/models.dart';
import 'package:parousia/reducers/remote_entities.dart';
import 'package:redux_entity/redux_entity.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'remote_entity_reducer_tester.dart';

void main() {
  group(profilesReducer, () {
    generator() => Profile(id: const Uuid().v4(), displayName: 'profile');

    final tester = RemoteEntityReducerTester<
        RemoteEntityReducer<RemoteEntityState<Profile>, Profile>,
        RemoteEntityState<Profile>,
        Profile>();

    return tester.testAll(
        profilesReducer, generator, const RemoteEntityState<Profile>());
  });

  group(groupsReducer, () {
    generator() => Group(id: Random().nextInt(256), displayName: 'group');

    final tester = RemoteEntityReducerTester<
        RemoteEntityReducer<RemoteEntityState<Group>, Group>,
        RemoteEntityState<Group>,
        Group>();

    return tester.testAll(
        groupsReducer, generator, const RemoteEntityState<Group>());
  });

  // TODO tests for nested entities
}
