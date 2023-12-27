import 'package:flutter/foundation.dart';

@immutable
class RequestDeleteReplyAction {
  final int memberId;
  final int scheduleId;
  final DateTime eventDate;

  const RequestDeleteReplyAction({
    required this.memberId,
    required this.scheduleId,
    required this.eventDate,
  });
}
