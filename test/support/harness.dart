import 'package:parousia/dependencies.dart';

import 'fake_backend.dart';
import 'preferences.dart';

/// The app's real repositories, wired as in main.dart, over a [FakeBackend].
Future<(FakeBackend, Repositories)> fakeApp({
  String? userId = 'me',
  void Function(FakeBackend backend)? seed,
}) async {
  useInMemoryPreferences();
  final backend = FakeBackend(userId: userId);
  seed?.call(backend);
  return (backend, await Repositories.create(backend.services));
}
