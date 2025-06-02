import 'package:flutter/material.dart';
import 'package:wishelf/widgets/popupmenu/popup_menu_item_with_icon.dart';

final class MoreVertPopupMenu extends StatelessWidget {
  final String? editTitle;
  final String? deleteTitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MoreVertPopupMenu({
    super.key,
    this.editTitle,
    this.deleteTitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder:
          (context) => [
            if (editTitle != null)
              PopupMenuItemWithIcon(
                value: 'edit',
                icon: Icons.edit,
                text: editTitle!,
                type: PopupMenuItemWithIconType.normal,
              ),
            if (deleteTitle != null)
              PopupMenuItemWithIcon(
                value: 'delete',
                icon: Icons.delete,
                text: deleteTitle!,
                type: PopupMenuItemWithIconType.destructive,
              ),
          ],
    );
  }
}
