import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/views/link_edit_screen.dart';
import 'package:wishelf/widgets/link_card.dart';
import 'package:wishelf/viewmodels/link_edit_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/widgets/dialog/delete_confirm_dialog.dart';
import 'package:wishelf/repositories/folder_repository.dart';

final class LinkListScreen extends StatelessWidget {
  final Folder folder;
  const LinkListScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final folders = context.watch<FolderRepository>().folders;

    return ChangeNotifierProvider<LinkEditViewModel>(
      create: (_) => LinkEditViewModel(context.read<FolderRepository>()),
      child: Consumer<LinkEditViewModel>(
        builder: (context, vm, _) {
          final updatedFolder = folders.firstWhere(
            (f) => f.id == folder.id,
            orElse: () => folder,
          );

          return Scaffold(
            appBar: AppBar(centerTitle: false, title: Text(folder.title)),
            body: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: updatedFolder.links.length,
              itemBuilder: (context, index) {
                return LinkCard(
                  item: updatedFolder.links[index],
                  status: LinkCardStatus.normal,
                  onTapMenu: (type) {
                    if (type == LinkCardMenuType.edit) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => ChangeNotifierProvider.value(
                                value: vm,
                                child: LinkEditScreen(
                                  initialItem: updatedFolder.links[index],
                                  folder: updatedFolder,
                                ),
                              ),
                          fullscreenDialog: true,
                        ),
                      );
                    } else if (type == LinkCardMenuType.delete) {
                      _showDeleteConfirmDialog(
                        context,
                        onConfirm: () {
                          vm.deleteLink(
                            folder.id,
                            updatedFolder.links[index].id,
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => ChangeNotifierProvider.value(
                          value: vm,
                          child: LinkEditScreen(
                            initialItem: null,
                            folder: updatedFolder,
                          ),
                        ),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          );
        },
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
          title: 'リンクの削除',
          message: '削除した場合、復元できません。\n本当に削除しますか？',
          confirmText: '削除',
          cancelText: 'キャンセル',
          onConfirm: onConfirm,
        );
      },
    );
  }
}
