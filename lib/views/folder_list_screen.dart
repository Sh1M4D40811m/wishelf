import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/viewmodels/folder_edit_view_model.dart';
import 'package:wishelf/views/link_list_screen.dart';
import 'package:wishelf/repositories/folder_repository.dart';
import 'package:wishelf/widgets/card/folder_card.dart';
import 'package:wishelf/util/dialog_util.dart';
import 'package:wishelf/models/folder.dart';

final class FolderListScreen extends StatelessWidget {
  const FolderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = context.watch<FolderRepository>().folders;
    final vm = FolderEditViewModel(context.read<FolderRepository>());

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("WiShelf")),
      body: _buildGridView(context, folders, vm),
      floatingActionButton: _buildFloatingActionButton(context, vm),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    List<Folder> folders,
    FolderEditViewModel vm,
  ) {
    return GridView.builder(
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
        return _buildFolderCard(context, folder, vm);
      },
    );
  }

  Widget _buildFolderCard(
    BuildContext context,
    Folder folder,
    FolderEditViewModel vm,
  ) {
    return FolderCard(
      folder: folder,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LinkListScreen(folder: folder)),
        );
      },
      onEdit: () {
        showFolderEditDialog(
          context: context,
          editingFolder: folder,
          onSubmit: (f) {
            vm.updateFolder(folder.id, f.title, f.colorHex);
          },
        );
      },
      onDelete: () {
        showDeleteConfirmDialog(
          context: context,
          title: 'フォルダの削除',
          message: 'フォルダ内のリンクも全て削除されます。\n削除した場合、復元できません。',
          onConfirm: () {
            vm.deleteFolder(folder.id);
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton(
    BuildContext context,
    FolderEditViewModel vm,
  ) {
    return FloatingActionButton(
      onPressed: () {
        showFolderEditDialog(
          context: context,
          onSubmit: (f) {
            vm.addFolder(f);
          },
        );
      },
      child: Icon(Icons.create_new_folder_outlined),
    );
  }
}
