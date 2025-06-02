import 'package:flutter/material.dart';
import 'package:wishelf/widgets/dialog/delete_confirm_dialog.dart';
import 'package:wishelf/widgets/dialog/folder_edit_dialog.dart';
import 'package:wishelf/models/folder.dart';

Future<void> showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (context) => DeleteConfirmDialog(
      title: title,
      message: message,
      confirmText: '削除',
      cancelText: 'キャンセル',
      onConfirm: onConfirm,
    ),
  );
}

Future<void> showFolderEditDialog({
  required BuildContext context,
  required Function(Folder) onSubmit,
  Folder? editingFolder,
}) {
  return showDialog(
    context: context,
    builder: (context) => FolderEditDialog(
      editingFolder: editingFolder,
      onSubmit: onSubmit,
    ),
  );
}
