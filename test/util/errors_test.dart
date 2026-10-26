import 'package:flutter_test/flutter_test.dart';
import 'package:parousia/util/errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('a gateway timeout is a network failure, not a bug', () {
    const timeout = PostgrestException(
      message: '',
      code: '504',
      details: 'Gateway Timeout',
    );
    expect(toAppException(timeout, StackTrace.empty), isA<NetworkException>());
  });

  test('other server errors are still unexpected', () {
    const error = PostgrestException(message: 'boom', code: '500');
    expect(toAppException(error, StackTrace.empty), isA<UnexpectedException>());
  });

  group('billing', () {
    AppException classify(Object error) =>
        toAppException(error, StackTrace.empty);

    test('the billing triggers\' refusals are explained', () {
      expect(
        classify(
          const PostgrestException(message: 'group_full', code: 'P0001'),
        ),
        isA<GroupFullException>(),
      );
      expect(
        classify(
          const PostgrestException(message: 'feature_locked', code: 'P0001'),
        ),
        isA<FeatureLockedException>(),
      );
      expect(
        classify(
          const PostgrestException(message: 'reply_locked', code: 'P0001'),
        ),
        isA<ReplyLockedException>(),
      );
      expect(
        classify(const PostgrestException(message: 'boom', code: 'P0001')),
        isA<UnexpectedException>(),
      );
    });
  });
}
