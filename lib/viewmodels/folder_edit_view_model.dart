import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/repositories/folder_repository.dart';

final class FolderEditViewModel extends ChangeNotifier {
  final FolderRepository repository;

  FolderEditViewModel(this.repository);

  void addFolder(Folder folder) => repository.addFolder(folder);

  void updateFolder(String id, String title, String color) =>
      repository.updateFolder(id, title, color);

  void deleteFolder(String id) => repository.deleteFolder(id);
}
