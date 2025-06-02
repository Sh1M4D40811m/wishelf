import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/widgets/folder_colors.dart';
import 'package:icon_decoration/icon_decoration.dart';

final class FolderDropdown extends StatelessWidget {
  final List<Folder> folders;
  final String? selectedFolderId;
  final ValueChanged<String?> onChanged;

  const FolderDropdown({
    super.key,
    required this.folders,
    required this.selectedFolderId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: '保存先フォルダ'),
      value: selectedFolderId,
      items: folders.map((folder) {
        return DropdownMenuItem<String>(
          value: folder.id,
          child: Row(
            children: [
              DecoratedIcon(
                icon: Icon(
                  Icons.folder,
                  color: FolderColor.fromHex(folder.colorHex).color,
                ),
                decoration: IconDecoration(
                  border: IconBorder(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(folder.title),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
