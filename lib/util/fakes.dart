import 'dart:math';

import 'package:faker/faker.dart';
import 'package:parousia/models/models.dart';
import 'package:parousia/util/recurrence_rules.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v7.dart';

/// Gnenerate fake data for testing
class Fake {
  static Profile profile() => Profile(
        id: const Uuid().v4(),
        displayName: faker.person.name(),
        picture: faker.image.image(height: 128, width: 128),
      );

  static Group group() => Group(
        id: const Uuid().v7(),
        displayName: faker.company.name(),
        description: faker.lorem.sentence(),
        picture: faker.image.image(height: 128, width: 128),
      );

  static Schedule schedule() => Schedule(
        id: const Uuid().v7(),
        groupId: const Uuid().v7(),
        displayName: faker.lorem.sentence(),
        recurrenceRule: CommonRecurrenceRules.monthly,
        startDate: DateTime.now(),
      );
}
