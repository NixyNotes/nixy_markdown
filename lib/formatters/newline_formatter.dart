import 'package:flutter/services.dart';

class NewlineFormatter extends TextInputFormatter {
  static const newlinePattern = '\r\n';
  static final spaceCharcode = ' '.codeUnitAt(0);
  static final periodCharcode = '.'.codeUnitAt(0);
  static bool isSpace(int code) => code == spaceCharcode;

  String _getPreviousLine(String text, int selectionStart) {
    final textLines = text.split('\n');
    final currentLine = _getLineNumber(text, selectionStart);

    if (currentLine > 0 && currentLine <= textLines.length) {
      return textLines[currentLine - 1];
    }

    return '';
  }

  int _getLineNumber(String text, int selectionStart) {
    final linesBeforeSelection = text.substring(0, selectionStart).split('\n');
    return linesBeforeSelection.length;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String? last;

    if (newValue.text.length > oldValue.text.length &&
        (last = lastCharacter(newValue)) != null &&
        newlinePattern.contains(last!)) {
      // Trim from right side and then split newline, get the latest line.
      final selectionStart = newValue.selection.start;
      final prevLine = _getPreviousLine(newValue.text, selectionStart - 1);
      final length = prevLine.runes.takeWhile(isSpace).length;
      final indent = "".padLeft(length);

      // If line includes any header catch it.
      String? header = bulletListHeader(prevLine, length);

      String before = newValue.selection.textBefore(newValue.text);
      int removedLength = 0;

      // If header is present but is null, remove header
      if (header == null) {
        header = '';
        final prev = lineTrimmed(prevLine, length);

        if (isEmptyHeader(prev)) {
          removedLength = prev.length + 1;
          before =
              '${before.substring(0, before.length - removedLength - 1)}\n\n';
        }
      }

      final value = [
        before,
        indent,
        header,
        newValue.selection.textInside(newValue.text),
        newValue.selection.textAfter(newValue.text)
      ].join();
      return newValue.copyWith(
        text: value,
        selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset +
              length +
              header.length -
              removedLength,
        ),
      );
    }

    return newValue;
  }

  bool isEmptyHeader(String input) =>
      const ['- [ ]', '- [x]', '-'].contains(input);

  String lineTrimmed(String line, int indent) =>
      String.fromCharCodes(line.runes.skip(indent)).trimRight();

  String? bulletListHeader(String prevLine, int indent) {
    final line = lineTrimmed(prevLine, indent);

    if (isEmptyHeader(line)) {
      return null;
    }

    if (line.startsWith('- [ ] ') || line.startsWith('- [x] ')) {
      return '- [ ] ';
    }
    if (line.startsWith('- ')) {
      return '- ';
    }
    return null;
  }

  String? lastCharacter(TextEditingValue val) {
    if (val.selection.isCollapsed && val.selection.start > 1) {
      return val.text[val.selection.start - 1];
    }
    return null;
  }
}
