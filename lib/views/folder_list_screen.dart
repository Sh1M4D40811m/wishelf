import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/viewmodels/folder_view_model.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/widgets/dialog/confirm_dialog.dart';
import 'package:wishelf/widgets/dialog/foler_edit_dialog.dart';

// TODO: リファクタ・初回起動時デフォルトフォルダを作成しておく
class FolderListScreen extends StatelessWidget {
  const FolderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folderVM = Provider.of<FolderViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("WiShelf")),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: folderVM.folders.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (_, index) {
          final folder = folderVM.folders[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            color: Color(int.parse(folder.colorHex, radix: 16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // TODO: Navigate to folder details
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        folder.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onSelected: (value) {
                        if (value == 'rename') {
                          _showFolderEditDialog(
                            context,
                            folderVM,
                            editingFolder: folder,
                          );
                        } else if (value == 'delete') {
                          _showConfirmDialog(
                            context,
                            onConfirm: () {
                              folderVM.deleteFolder(folder.id);
                            },
                          );
                        }
                      },
                      itemBuilder:
                          (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'rename',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  SizedBox(width: 8),
                                  Text('名前を変更'),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '削除',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFolderEditDialog(context, folderVM);
        },
        child: Icon(Icons.create_new_folder_outlined),
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: 'フォルダの削除',
          message: 'フォルダ内のリンクも全て削除されます。\n削除した場合、復元できません',
          confirmText: '削除',
          cancelText: 'キャンセル',
          onConfirm: onConfirm,
        );
      },
    );
  }

  void _showFolderEditDialog(
    BuildContext context,
    FolderViewModel viewModel, {
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
