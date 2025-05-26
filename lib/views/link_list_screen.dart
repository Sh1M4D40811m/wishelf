import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/views/link_edit_screen.dart';

final class LinkListScreen extends StatelessWidget {
  final Folder folder;
  const LinkListScreen({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: Text(folder.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 11,
              itemBuilder: (context, index) {
                return _buildLinkCard(context, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => LinkEditScreen(
                    initialItem: null,
                    onSubmit: (
                      url,
                      title,
                      folderId,
                    ) {},
                    folder: folder,
                  ),
              fullscreenDialog: true,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: 120,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: _buildCardContents(context, index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContents(BuildContext context, int index) {
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.link), // リンク画像
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "リンクタイトル",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 1,
              ),
              Text(
                "リンク説明",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        _buildMoreMenu(context),
      ],
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (value) {
        if (value == 'edit') {
          // TODO: add edit action
        } else if (value == 'delete') {
          // TODO: add delete action
        }
      },
      itemBuilder:
          (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
    );
  }
}
