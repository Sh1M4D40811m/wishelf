import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/folder.dart';

final class StorageService {
  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/wishelf.json');
  }

  Future<void> saveFolders(List<Folder> folders) async {
    final file = await _getLocalFile();
    final encoded = jsonEncode(folders.map((f) => f.toJson()).toList());
    await file.writeAsString(encoded);
  }

  Future<List<Folder>> loadFolders() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> decoded = jsonDecode(contents);
      return decoded.map((e) => Folder.fromJson(e)).toList();
    } catch (e) {
      print('Error loading folders: $e');
      return [];
    }
  }
}