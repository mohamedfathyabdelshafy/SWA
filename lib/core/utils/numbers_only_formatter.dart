import 'package:flutter/services.dart';

class NumbersOnlyFormatter extends TextInputFormatter {
  final RegExp _allowedNumbers = RegExp(r'[\u0660-\u0669\u0030-\u0039]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String filtered =
        newValue.text
            .split('')
            .where((char) => _allowedNumbers.hasMatch(char))
            .join();

    return newValue.copyWith(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}
