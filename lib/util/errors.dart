import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' show ClientException;
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'result.dart';

/// A failure the app expects and can explain to the user.
///
/// Anything else becomes an [UnexpectedException], which is reported.
sealed class AppException implements Exception {
  const AppException();
}

/// The server could not be reached.
final class NetworkException extends AppException {
  const NetworkException();
}

/// The row is gone, or row-level security hides it from this user. A write
/// that matched no rows ends up here too: the server can't tell us which.
final class NotFoundException extends AppException {
  const NotFoundException();
}

/// Row-level security rejected a write.
final class NotAllowedException extends AppException {
  const NotAllowedException();
}

/// No pending invite has this code.
final class InvalidInviteCodeException extends AppException {
  const InvalidInviteCodeException();
}

/// The invite is for a group the user already belongs to.
final class AlreadyMemberException extends AppException {
  const AlreadyMemberException();
}

/// The action needs a signed-in user, and there isn't one (any more).
final class NotSignedInException extends AppException {
  const NotSignedInException();
}

/// Every seat of the group is taken: no one more can be invited.
final class GroupFullException extends AppException {
  const GroupFullException();
}

/// The group's plan doesn't include the feature the change needs.
final class FeatureLockedException extends AppException {
  const FeatureLockedException();
}

/// Changes to this event's answers have closed (a reply cutoff).
final class ReplyLockedException extends AppException {
  const ReplyLockedException();
}

/// The group already has a plan: changing it goes through its payer.
final class AlreadyFundedException extends AppException {
  const AlreadyFundedException();
}

/// A bug, or a response the app doesn't understand.
final class UnexpectedException extends AppException {
  const UnexpectedException(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;

  @override
  String toString() => 'UnexpectedException: $error';
}

/// Classifies anything thrown by the data layer.
AppException toAppException(Object error, StackTrace stackTrace) =>
    switch (error) {
      AppException() => error,
      ClientException() ||
      TimeoutException() ||
      AuthRetryableFetchException() => const NetworkException(),
      // A gateway in front of PostgREST timed out or is down: a non-JSON
      // body, so the HTTP status becomes the code.
      PostgrestException(code: '502' || '503' || '504' || '520') =>
        const NetworkException(),
      // PostgREST: .single() matched no rows.
      PostgrestException(code: 'PGRST116') => const NotFoundException(),
      // Postgres: insufficient_privilege, e.g. a row-level security violation.
      PostgrestException(code: '42501') => const NotAllowedException(),
      // Raised by the billing triggers (docs/billing-and-entitlements.md).
      PostgrestException(code: 'P0001', message: 'group_full') =>
        const GroupFullException(),
      PostgrestException(code: 'P0001', message: 'feature_locked') =>
        const FeatureLockedException(),
      PostgrestException(code: 'P0001', message: 'reply_locked') =>
        const ReplyLockedException(),
      // Edge Functions: no response at all (status 0), or a gateway's.
      FunctionException(status: 0 || 502 || 503 || 504) =>
        const NetworkException(),
      FunctionException(details: {'error': 'already_funded'}) =>
        const AlreadyFundedException(),
      FunctionException(status: 401) => const NotSignedInException(),
      FunctionException(status: 403) => const NotAllowedException(),
      FunctionException(status: 404) => const NotFoundException(),
      _ => UnexpectedException(error, stackTrace),
    };

/// Turns anything thrown into an [Error], reporting the unexpected ones.
Result<T> failure<T>(Object error, StackTrace stackTrace) {
  final exception = toAppException(error, stackTrace);
  if (exception is UnexpectedException) {
    log('$error', name: 'parousia', error: error, stackTrace: stackTrace);
    Sentry.captureException(error, stackTrace: stackTrace);
  }
  return Result.error(exception);
}

/// Runs [action]: its value becomes an [Ok], anything it throws an [Error].
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Result.ok(await action());
  } catch (error, stackTrace) {
    return failure(error, stackTrace);
  }
}
