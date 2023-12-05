/// Convert a name into upper case initials
String? getNameInitials(String? name) => name
    ?.split(' ')
    .map((e) => e.isNotEmpty ? e[0] : '')
    .take(3)
    .join('')
    .toUpperCase();
