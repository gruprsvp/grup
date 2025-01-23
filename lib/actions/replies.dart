import 'package:flutter/foundation.dart';

import 'package:parousia/brick/brick.dart';

@immutable
class RequestDeleteReplyAction {
  final Reply reply;

  const RequestDeleteReplyAction({
    required this.reply,
  });
}
