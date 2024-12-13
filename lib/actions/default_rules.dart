import 'package:flutter/foundation.dart';

@immutable
class RequestDeleteDefaultRuleAction {
  final int memberId;
  final int scheduleId;

  const RequestDeleteDefaultRuleAction({
    required this.memberId,
    required this.scheduleId,
  });
}
