import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

@immutable
class SaveProfileAction {
  const SaveProfileAction({this.name, this.image});

  final String? name;
  final XFile? image;
}
