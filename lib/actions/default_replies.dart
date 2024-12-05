import 'package:flutter/foundation.dart';

@immutable
class RequestDeleteDefaultReplyAction {
  final int memberId;
  final int scheduleId;

  const RequestDeleteDefaultReplyAction({
    required this.memberId,
    required this.scheduleId,
  });
}
