import 'package:flutter/foundation.dart';
import 'package:parousia/brick/brick.dart';

@immutable
class RequestDeleteDefaultRuleAction {
  final DefaultRule defaultRule;

  const RequestDeleteDefaultRuleAction({
    required this.defaultRule,
  });
}
