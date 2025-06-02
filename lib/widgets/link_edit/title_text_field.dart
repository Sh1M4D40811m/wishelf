import 'package:flutter/material.dart';

final class TitleTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final VoidCallback onClear;

  const TitleTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.errorText,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'タイトルを編集',
        hintText: 'リンクから自動入力されます',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        errorText: errorText,
        suffixIcon: focusNode.hasFocus
            ? IconButton(
                icon: Icon(Icons.cancel_outlined),
                onPressed: onClear,
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '必須項目です。';
        }
        return null;
      },
    );
  }
}
