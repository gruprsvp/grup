import 'package:flutter/foundation.dart';

@immutable
class NavigatePushAction {
  const NavigatePushAction(this.location, {this.extra});

  final String location;
  final Object? extra;
}

@immutable
class NavigateReplaceAction {
  const NavigateReplaceAction(this.location);

  final String location;
}
