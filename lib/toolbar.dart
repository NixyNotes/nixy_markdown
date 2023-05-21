import 'package:flutter/widgets.dart';

class NixiMarkdownToolbarTools {
  NixiMarkdownToolbarTools(this.textController);
  final TextEditingController textController;

  void bold() => _wrap(left: '**');
  void italic() => _wrap(left: '*');
  void strikethrough() => _wrap(left: '~~');
  void mathText() => _wrap(left: '\$');
  void mathEnvironment(String environment) => _wrap(
        left: '\$\$\\begin{$environment}\n',
        right: '\\end{$environment}\$\$',
      );

  void _wrap({
    required String left,
    String? right,
  }) {
    right ??= left;
    final sel = textController.selection;
    final text = textController.text;

    final output = [
      sel.textBefore(text),
      left,
      sel.textInside(text),
      right,
      sel.textAfter(text)
    ].join();

    textController.value = TextEditingValue(
      text: output,
      selection: sel.copyWith(
        baseOffset: sel.baseOffset + left.length,
        extentOffset: sel.extentOffset + left.length,
      ),
    );
  }
}
