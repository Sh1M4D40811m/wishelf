import 'package:flutter/material.dart';
import 'package:wishelf/models/folder.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/services/storage_service.dart';

final class LinkEditViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();
  final List<Folder> _folders = [];
  List<Folder> get folders => List.unmodifiable(_folders);

  Future<void> loadFolders() async {
    final loaded = await _storage.loadFolders();
    _folders.clear();
    _folders.addAll(loaded);
    notifyListeners();
  }

  void addLinkToFolder(String folderId, LinkItem link) {
    final index = _folders.indexWhere((f) => f.id == folderId);
    if (index != -1) {
      _folders[index].links.add(link);
      _storage.saveFolders(_folders);
      notifyListeners();
    }
  }

  void deleteLinkFromFolder(String folderId, String linkId) {
    final index = _folders.indexWhere((f) => f.id == folderId);
    if (index != -1) {
      _folders[index].links.removeWhere((link) => link.id == linkId);
      _storage.saveFolders(_folders);
      notifyListeners();
    }
  }
}
