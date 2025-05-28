import 'package:flutter/material.dart';
import 'package:wishelf/models/link.dart';
import 'package:wishelf/repositories/folder_repository.dart';

final class LinkEditViewModel extends ChangeNotifier {
  final FolderRepository repository;

  LinkEditViewModel(this.repository);

  void addLink(String folderId, LinkItem link) =>
      repository.addLinkToFolder(folderId, link);

  void updateLink(String folderId, LinkItem link) =>
      repository.updateLinkInFolder(folderId, link);

  void deleteLink(String folderId, String linkId) =>
      repository.deleteLinkFromFolder(folderId, linkId);
}
