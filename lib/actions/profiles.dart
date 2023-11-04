import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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

@immutable
class UpdateProfileAction {
  const UpdateProfileAction({this.name, this.image});

  final String? name;
  final XFile? image;
}
