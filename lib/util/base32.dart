import 'package:flutter/services.dart';

const _crockford = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/// A [TextInputFormatter] that formats input as a Crockford Base32 string,
/// replacing visually similar characters and adding a hyphen in the middle.
class Base32TextInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final normalised = cleanBase32Code(newValue.text);
    final formatted = formatBase32Code(normalised);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String cleanBase32Code(String code) {
  return code
      .toUpperCase()
      .replaceAll(RegExp(r'O'), '0')
      .replaceAll(RegExp(r'[IL]'), '1')
      .split('')
      .where((char) => _crockford.contains(char))
      .join();
}

String formatBase32Code(String code) {
  return code.length > 4
      ? "${code.substring(0, 4)}-${code.substring(4)}"
      : code;
}
