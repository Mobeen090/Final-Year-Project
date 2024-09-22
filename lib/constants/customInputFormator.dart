import 'package:flutter/services.dart';

class CustomFormatter extends TextInputFormatter {
  CustomFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        return TextEditingValue(text: newValue.text.trimLeft(), selection: TextSelection.collapsed(offset: newValue.text.trim().isNotEmpty ? newValue.selection.end : 0));
      } else {
        return newValue;
      }
    }
    return newValue;
  }
}