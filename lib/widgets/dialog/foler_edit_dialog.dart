import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';

class FolderEditDialog extends StatefulWidget {
  final Folder? editingFolder;
  final void Function(Folder folder) onSubmit;
  
  const FolderEditDialog({
    super.key,
    required this.editingFolder,
    required this.onSubmit,
  });

  @override
  State<FolderEditDialog> createState() => _FolderEditDialogState();
}

class _FolderEditDialogState extends State<FolderEditDialog> {
  late TextEditingController _titleController;
  late FocusNode _focusNode;
  late String _selectedColor;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.editingFolder?.title ?? '');
    _focusNode = FocusNode();
    _selectedColor = widget.editingFolder?.colorHex ?? '0xFFFFFFFF';
    _isButtonEnabled = _titleController.text.trim().isNotEmpty;

    _titleController.addListener(() {
      final isNotEmpty = _titleController.text.trim().isNotEmpty;
      if (isNotEmpty != _isButtonEnabled) {
        setState(() {
          _isButtonEnabled = isNotEmpty;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editingFolder != null ? 'フォルダを編集' : 'フォルダの新規作成'),
      titleTextStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            focusNode: _focusNode,
            decoration: InputDecoration(labelText: 'フォルダ名'),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedColor,
            decoration: InputDecoration(labelText: 'カラー'),
            items: [
              {'name': 'ミルク', 'hex': '0xFFFFFFFF'},
              {'name': 'カフェオレ', 'hex': '0xFFECD4C2'},
              {'name': 'ココア', 'hex': '0xFFDCBCB6'},
              {'name': 'クリームソーダ', 'hex': '0xFFF4FFEA'},
              {'name': 'ラムネ', 'hex': '0xFFE2FBFC'},
              {'name': 'レモネード', 'hex': '0xFFFFFCC8'},
            ].map((color) {
              return DropdownMenuItem<String>(
                value: color['hex'],
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Color(int.parse(color['hex']!)),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(color['name']!),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedColor = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('キャンセル'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: _isButtonEnabled
              ? () {
                  final title = _titleController.text.trim();
                  final folder = Folder(
                    id: widget.editingFolder?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    colorHex: _selectedColor,
                  );
                  widget.onSubmit(folder);
                  Navigator.pop(context);
                }
              : null,
          child: Text(widget.editingFolder != null ? '保存' : '追加'),
        ),
      ],
    );
  }
}
