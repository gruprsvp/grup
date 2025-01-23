import 'package:faker/faker.dart';
import 'package:parousia/brick/brick.dart';
import 'package:parousia/util/recurrence_rules.dart';

/// Gnenerate fake data for testing
class Fake {
  static Profile profile() => Profile(
        displayName: faker.person.name(),
        picture: faker.image.loremPicsum(height: 128, width: 128),
      );

  static Group group() => Group(
        displayName: faker.company.name(),
        description: faker.lorem.sentence(),
        picture: faker.image.loremPicsum(height: 512, width: 512),
      );

  static Schedule schedule() => Schedule(
        group: group(),
        displayName: faker.lorem.sentence(),
        recurrenceRule: CommonRecurrenceRules.daily,
        startDate: DateTime.now(),
        timezone: 'Europe/Zurich',
      );
}
