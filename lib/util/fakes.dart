import 'package:faker/faker.dart';
import 'package:parousia/models/models.dart';

/// Gnenerate fake data for testing
class Fake {
  static Group group() => Group(
        displayName: faker.company.name(),
        description: faker.lorem.sentence(),
        picture: faker.image.image(height: 128, width: 128),
        id: 0,
      );
}
