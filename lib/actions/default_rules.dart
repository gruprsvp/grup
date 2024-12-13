import 'package:flutter/foundation.dart';

@immutable
class RequestDeleteDefaultRuleAction {
  final String memberId;
  final String scheduleId;

  const RequestDeleteDefaultRuleAction({
    required this.memberId,
    required this.scheduleId,
  });
}
