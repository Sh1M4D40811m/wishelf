import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/services/storage_service.dart';

final class FolderEditViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Folder> _folders = [];
  List<Folder> get folders => _folders;

  Future<void> loadFolders() async {
    _folders = await _storage.loadFolders();
    notifyListeners();
  }

  void addFolder(Folder folder) {
    _folders.add(folder);
    _storage.saveFolders(_folders);
    notifyListeners();
  }

  void updateFolder(String id, String newTitle, String newColorHex) {
    final index = folders.indexWhere((f) => f.id == id);
    if (index != -1) {
      folders[index] = Folder(
        id: folders[index].id,
        title: newTitle,
        colorHex: newColorHex,
      );
      _storage.saveFolders(_folders);
      notifyListeners();
    }
  }

  void deleteFolder(String id) {
    _folders.removeWhere((folder) => folder.id == id);
    _storage.saveFolders(_folders);
    notifyListeners();
  }
}
