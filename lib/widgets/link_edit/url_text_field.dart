import 'package:flutter/material.dart';

final class UrlTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onPaste;

  const UrlTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.errorText,
    required this.onChanged,
    required this.onClear,
    required this.onPaste,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'リンクを貼り付け',
        hintText: 'https://example.com',
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        errorText: errorText,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.paste_outlined),
              onPressed: onPaste,
            ),
            IconButton(
              icon: Icon(Icons.cancel_outlined),
              onPressed: onClear,
            ),
          ],
        ),
      ),
      keyboardType: TextInputType.url,
      onChanged: onChanged,
    );
  }
}
