export 'timezone_stub.dart'
    if (dart.library.io) 'package:timezone/standalone.dart'
    if (dart.library.html) 'package:timezone/browser.dart';
