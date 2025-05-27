import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/views/link_edit_screen.dart';
import 'package:wishelf/widgets/link_card.dart';
import 'package:wishelf/viewmodels/link_edit_view_model.dart';
import 'package:provider/provider.dart';

final class LinkListScreen extends StatelessWidget {
  final Folder folder;
  const LinkListScreen({super.key, required this.folder});

@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LinkEditViewModel>(
      create: (_) => LinkEditViewModel()..loadFolders(),
      child: Consumer<LinkEditViewModel>(
        builder: (context, vm, _) {
          final updatedFolder = vm.folders.firstWhere(
            (f) => f.id == folder.id,
            orElse: () => folder,
          );

          return Scaffold(
            appBar: AppBar(centerTitle: false, title: Text(folder.title)),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: updatedFolder.links.length,
              itemBuilder: (context, index) {
                return LinkCard(
                  item: updatedFolder.links[index],
                  status: LinkCardStatus.normal,
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
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
}
