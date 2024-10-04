import 'package:flutter/services.dart';

const _crockford = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/// A [TextInputFormatter] that formats input as a Crockford Base32 string,
/// replacing visually similar characters and adding a hyphen in the middle.
class Base32TextInputFormatter implements TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final normalised = newValue.text
        .toUpperCase()
        .replaceAll(RegExp(r'O'), '0')
        .replaceAll(RegExp(r'[IL]'), '1')
        .split('')
        .where((char) => _crockford.contains(char))
        .join();

    final formatted = normalised.length > 4
        ? "${normalised.substring(0, 4)}-${normalised.substring(4)}"
        : normalised;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
