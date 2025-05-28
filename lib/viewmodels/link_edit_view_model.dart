import 'package:flutter/material.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/repositories/folder_repository.dart';

final class LinkEditViewModel extends ChangeNotifier {
  final FolderRepository repository;

  LinkEditViewModel(this.repository);

  Future<void> saveLink({
    required LinkItem link,
    required String targetFolderId,
    String? originalFolderId,
  }) async {
    if (originalFolderId == null) {
      await repository.addLinkToFolder(targetFolderId, link);
    } else if (originalFolderId == targetFolderId) {
      await repository.updateLinkInFolder(targetFolderId, link);
    } else {
      await repository.deleteLinkFromFolder(originalFolderId, link.id);
      await repository.addLinkToFolder(targetFolderId, link);
    }
    notifyListeners();
  }

  void deleteLink(String folderId, String linkId) =>
      repository.deleteLinkFromFolder(folderId, linkId);
}
