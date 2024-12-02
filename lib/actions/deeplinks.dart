import 'package:flutter/foundation.dart';

/// Dispatched when a deeplink is used.
@immutable
class HandleDeeplinkAction {
  final String route;
  final List<String> paths;

  const HandleDeeplinkAction._(this.route, this.paths);

  factory HandleDeeplinkAction(String route) {
    final paths = route.split('/').skip(1).toList();
    return HandleDeeplinkAction._(route, paths);
  }
}
