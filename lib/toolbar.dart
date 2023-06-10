import 'package:flutter/widgets.dart';

class NixiMarkdownToolbarTools {
  NixiMarkdownToolbarTools(this.textController);
  final TextEditingController textController;

  void checkBoxList() => _wrap(left: "- [ ] ");
  void list() => _wrap(left: "- ");
  void h1() => _wrap(left: '# ');
  void h2() => _wrap(left: '## ');
  void h3() => _wrap(left: '### ');
  void h4() => _wrap(left: '#### ');
  void h5() => _wrap(left: '##### ');
  void h6() => _wrap(left: '###### ');
  void bold() => _wrap(left: '**', right: "**");
  void italic() => _wrap(left: '*', right: "*");
  void strikethrough() => _wrap(left: '~~', right: "~~");
  void mathText() => _wrap(left: '\$', right: '\$');
  void mathEnvironment(String environment) => _wrap(
        left: '\$\$\\begin{$environment}\n',
        right: '\\end{$environment}\$\$',
      );

  void _wrap({
    required String left,
    String? right,
  }) {
    final sel = textController.selection;
    final text = textController.text;

    final output = [
      sel.textBefore(text),
      left,
      sel.textInside(text),
    ];

    if (right != null) {
      output.addAll([right, sel.textAfter(text)]);
    }

    textController.value = TextEditingValue(
      text: output.join(),
      selection: sel.copyWith(
        baseOffset: sel.baseOffset + left.length,
        extentOffset: sel.extentOffset + left.length,
      ),
    );
  }
}
