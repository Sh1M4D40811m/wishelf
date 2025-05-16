import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/widgets/folder_colors.dart';

final class FolderEditDialog extends StatefulWidget {
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

final class _FolderEditDialogState extends State<FolderEditDialog> {
  late TextEditingController _titleController;
  late FocusNode _focusNode;
  late String _selectedColor;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.editingFolder?.title ?? '',
    );
    _focusNode = FocusNode();
    _selectedColor = widget.editingFolder?.colorHex ?? FolderColor.milk.hex;
    _isButtonEnabled = _titleController.text.trim().isNotEmpty;

    _titleController.addListener(_validateInput);

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
      title: Text(widget.editingFolder != null ? 'フォルダの編集' : 'フォルダの新規作成'),
      titleTextStyle: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(),
          SizedBox(height: 16),
          _buildColorDropdown(context),
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
          onPressed: _isButtonEnabled ? _handleSubmit : null,
          child: Text(widget.editingFolder != null ? '保存' : '追加'),
        ),
      ],
    );
  }

  void _validateInput() {
    final isNotEmpty = _titleController.text.trim().isNotEmpty;
    if (isNotEmpty != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isNotEmpty;
      });
    }
  }

  void _handleSubmit() {
    final folder = _buildFolder();
    widget.onSubmit(folder);
    Navigator.pop(context);
  }

  Folder _buildFolder() {
    return Folder(
      id:
          widget.editingFolder?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      colorHex: _selectedColor,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _titleController,
      focusNode: _focusNode,
      decoration: InputDecoration(labelText: 'フォルダ名'),
    );
  }

  Widget _buildColorDropdown(BuildContext context) {
    return DropdownButtonFormField<FolderColor>(
      value: FolderColor.fromHex(_selectedColor),
      decoration: InputDecoration(labelText: 'カラー'),
      items:
          FolderColor.values.map((color) {
            return DropdownMenuItem<FolderColor>(
              value: color,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: color.color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(color.label),
                ],
              ),
            );
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedColor = value.hex;
          });
        }
      },
    );
  }
}
