import 'package:flutter/services.dart';

class LettersOnlyFormatter extends TextInputFormatter {
  final RegExp _allowedChars = RegExp(
    r'[\u0621-\u064Aa-zA-Z\s]',
  ); // Arabic + English letters + space

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filtered =
        newValue.text
            .split('')
            .where((char) => _allowedChars.hasMatch(char))
            .join();

    return newValue.copyWith(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}
