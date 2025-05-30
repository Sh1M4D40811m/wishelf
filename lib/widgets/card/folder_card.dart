import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/widgets/popup_menu_item_with_icon.dart';

final class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      color: Color(int.parse(folder.colorHex, radix: 16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
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
                  if (value == 'edit') {
                    onEdit();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder:
                    (BuildContext context) => [
                      PopupMenuItemWithIcon(
                        value: 'edit',
                        icon: Icons.edit,
                        text: 'フォルダの編集',
                        type: PopupMenuItemWithIconType.normal,
                      ),
                      PopupMenuItemWithIcon(
                        value: 'delete',
                        icon: Icons.delete,
                        text: '削除',
                        type: PopupMenuItemWithIconType.destructive,
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
