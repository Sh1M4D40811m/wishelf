import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/services/storage_service.dart';

class FolderRepository extends ChangeNotifier {
  final _storage = StorageService();
  List<Folder> _folders = [];
  List<Folder> get folders => List.unmodifiable(_folders);

  Future<void> load() async {
    _folders = await _storage.loadFolders();
    notifyListeners();
  }

  Future<void> save() async {
    await _storage.saveFolders(_folders);
    notifyListeners();
  }

  void addFolder(Folder folder) {
    _folders.add(folder);
    save();
  }

  void updateFolder(String id, String newTitle, String newColorHex) {
    final index = _folders.indexWhere((f) => f.id == id);
    if (index != -1) {
      _folders[index].title = newTitle;
      _folders[index].colorHex = newColorHex;
      save();
    }
  }

  void deleteFolder(String id) {
    _folders.removeWhere((f) => f.id == id);
    save();
  }

  Future<void> addLinkToFolder(String folderId, LinkItem link) async {
    final folder = _folders.firstWhere((f) => f.id == folderId, orElse: () => throw Exception("Folder not found"));
    folder.links.add(link);
    await save();
  }

  Future<void>  updateLinkInFolder(String folderId, LinkItem updatedLink) async {
    final folder = _folders.firstWhere((f) => f.id == folderId, orElse: () => throw Exception("Folder not found"));
    final index = folder.links.indexWhere((l) => l.id == updatedLink.id);
    if (index != -1) {
      folder.links[index] = updatedLink;
      await save();
    }
  }

  Future<void>  deleteLinkFromFolder(String folderId, String linkId) async {
    final folder = _folders.firstWhere((f) => f.id == folderId, orElse: () => throw Exception("Folder not found"));
    folder.links.removeWhere((l) => l.id == linkId);
    await save();
  }
}