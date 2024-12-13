import 'package:flutter/foundation.dart';

@immutable
class RequestDeleteReplyAction {
  final String memberId;
  final String scheduleId;
  final DateTime instanceDate;

  const RequestDeleteReplyAction({
    required this.memberId,
    required this.scheduleId,
    required this.instanceDate,
  });
}
