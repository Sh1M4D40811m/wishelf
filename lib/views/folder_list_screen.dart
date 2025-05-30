import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/viewmodels/folder_edit_view_model.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/widgets/dialog/delete_confirm_dialog.dart';
import 'package:wishelf/widgets/dialog/folder_edit_dialog.dart';
import 'package:wishelf/views/link_list_screen.dart';
import 'package:wishelf/repositories/folder_repository.dart';
import 'package:wishelf/widgets/card/folder_card.dart';

final class FolderListScreen extends StatelessWidget {
  const FolderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = context.watch<FolderRepository>().folders;
    final vm = FolderEditViewModel(context.read<FolderRepository>());

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("WiShelf")),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: folders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, index) {
          final folder = folders[index];
          return FolderCard(
            folder: folder,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LinkListScreen(folder: folder),
                ),
              );
            },
            onEdit: () {
              _showFolderEditDialog(context, vm, editingFolder: folder);
            },
            onDelete: () {
              _showDeleteConfirmDialog(
                context,
                onConfirm: () {
                  vm.deleteFolder(folder.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFolderEditDialog(context, vm);
        },
        child: Icon(Icons.create_new_folder_outlined),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmDialog(
          title: 'フォルダの削除',
          message: 'フォルダ内のリンクも全て削除されます。\n削除した場合、復元できません。',
          confirmText: '削除',
          cancelText: 'キャンセル',
          onConfirm: onConfirm,
        );
      },
    );
  }

  void _showFolderEditDialog(
    BuildContext context,
    FolderEditViewModel viewModel, {
    Folder? editingFolder,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return FolderEditDialog(
          editingFolder: editingFolder,
          onSubmit: (folder) {
            if (editingFolder != null) {
              viewModel.updateFolder(
                editingFolder.id,
                folder.title,
                folder.colorHex,
              );
            } else {
              viewModel.addFolder(folder);
            }
          },
        );
      },
    );
  }
}
