import 'package:flutter/widgets.dart';

/// Convert a name into upper case initials
String? getNameInitials(String? name) => name
    // An aside isn't part of the name: "Tom (no app)" is T, not T(A.
    ?.replaceAll(RegExp(r'\s*\(.*?\)'), '')
    .split(' ')
    .map((e) => e.isNotEmpty ? e.characters.first : '')
    .take(3)
    .join('')
    .toUpperCase();
