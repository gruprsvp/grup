import 'package:flutter/foundation.dart';
import 'package:parousia/models/models.dart';

@immutable
class OwnProfileLoadedAction {
  const OwnProfileLoadedAction(this.profile);

  final Profile profile;
}

@immutable
class OwnProfileLoadErrorAction {
  const OwnProfileLoadErrorAction(this.error);

  final Object error;
}
