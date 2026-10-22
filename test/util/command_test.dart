import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/util/command.dart';
import 'package:parousia/util/errors.dart';
import 'package:parousia/util/result.dart';

void main() {
  test(
    'an action that throws ends as an Error, not an uncaught error',
    () async {
      final command = Command0<void>(() => throw StateError('bug'));

      await command.execute();

      expect(command.running, isFalse);
      expect(command.error, isTrue);
      expect((command.result! as Error).error, isA<UnexpectedException>());
    },
  );

  test('expected failures keep their type', () async {
    final command = Command1<void, String>(
      (_) async => const Result.error(NotFoundException()),
    );

    await command.execute('id');

    expect((command.result! as Error).error, isA<NotFoundException>());
  });

  test('cannot run again while running', () async {
    final gate = Completer<void>();
    var runs = 0;
    final command = Command0<void>(() async {
      runs++;
      await gate.future;
      return const Result.ok(null);
    });

    final first = command.execute();
    await command.execute(); // ignored: the first is still running
    gate.complete();
    await first;

    expect(runs, 1);
    expect(command.completed, isTrue);
  });
}
