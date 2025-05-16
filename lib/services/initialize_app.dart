import 'package:wishelf/models/folder.dart';
import 'package:wishelf/services/storage_service.dart';
import 'package:wishelf/widgets/folder_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeApp() async {
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    final defaultFolder = Folder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'リスト',
      colorHex: FolderColors.values[0].hex,
    );

    final storage = StorageService();
    await storage.saveFolders([defaultFolder]);

    await prefs.setBool('isFirstLaunch', false);
  }
}
