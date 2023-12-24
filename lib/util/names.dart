import 'package:flutter/widgets.dart';

/// Convert a name into upper case initials
String? getNameInitials(String? name) => name
    ?.split(' ')
    .map((e) => e.isNotEmpty ? e.characters.first : '')
    .take(3)
    .join('')
    .toUpperCase();
