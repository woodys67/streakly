import 'package:flutter/services.dart';

/// 영문(ASCII 0x20~0x7E)만 허용하는 TextInputFormatter.
/// 비ASCII 문자가 입력될 경우 [onBlocked] 콜백을 호출.
class AsciiOnlyFormatter extends TextInputFormatter {
  final VoidCallback? onBlocked;

  AsciiOnlyFormatter({this.onBlocked});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = String.fromCharCodes(
      newValue.text.codeUnits.where((c) => c >= 0x20 && c <= 0x7E),
    );
    if (filtered != newValue.text) {
      onBlocked?.call();
      return newValue.copyWith(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }
    return newValue;
  }
}
