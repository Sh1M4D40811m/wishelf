import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/folder_view_model.dart';
import '../models/folder.dart';

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
            color: Color(int.parse(folder.colorHex)),
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
                          _showEditFolderDialog(
                            context,
                            folderVM,
                            editingFolder: folder,
                          );
                        } else if (value == 'delete') {
                          _showDeleteConfirmDialog(
                            context,
                            folderVM,
                            folderId: folder.id,
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
          _showEditFolderDialog(context, folderVM);
        },
        child: Icon(Icons.create_new_folder_outlined),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    FolderViewModel viewModel, {
    required String folderId,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(width: 4),
              Text('フォルダを削除'),
            ],
          ),
          titleTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          content: Text('フォルダ内のリンクも全て削除されます。\n削除した場合、復元できません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('キャンセル'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                viewModel.deleteFolder(folderId);
                Navigator.pop(context);
              },
              child: Text('削除'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFolderDialog(
    BuildContext context,
    FolderViewModel viewModel, {
    Folder? editingFolder,
  }) {
    final titleController = TextEditingController(
      text: editingFolder?.title ?? '',
    );
    final focusNode = FocusNode();
    String selectedColor = editingFolder?.colorHex ?? '0xFFFFFFFF';
    bool isButtonEnabled = titleController.text.trim().isNotEmpty;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              focusNode.requestFocus();
            });

            titleController.addListener(() {
              final isNotEmpty = titleController.text.trim().isNotEmpty;
              if (isButtonEnabled != isNotEmpty) {
                setState(() {
                  isButtonEnabled = isNotEmpty;
                });
              }
            });

            return AlertDialog(
              title: Text(editingFolder != null ? 'フォルダを編集' : 'フォルダの新規作成'),
              titleTextStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'フォルダ名'),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedColor,
                    decoration: InputDecoration(labelText: 'カラー'),
                    items:
                        [
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
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
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
                          selectedColor = value;
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
                  onPressed:
                      isButtonEnabled
                          ? () {
                            final title = titleController.text.trim();
                            if (editingFolder != null) {
                              viewModel.updateFolder(
                                editingFolder.id,
                                title,
                                selectedColor,
                              );
                            } else {
                              viewModel.addFolder(
                                Folder(
                                  id:
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString(),
                                  title: title,
                                  colorHex: selectedColor,
                                ),
                              );
                            }
                            Navigator.pop(context);
                          }
                          : null,
                  child: Text(editingFolder != null ? '保存' : '追加'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
