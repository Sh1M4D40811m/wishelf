import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/services/initialize_app.dart';
import 'viewmodels/folder_edit_view_model.dart';
import 'package:wishelf/views/folder_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FolderEditViewModel()..loadFolders(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiShelf',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: const Color(0xFFB7A9AA),
        cardColor: const Color(0xFFFFFFFF),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color(0xFF624A2E),
          onPrimary: const Color(0xFFEFEDE6),
          secondary: const Color(0xFFE4DAD4),
          onSecondary: const Color(0xFFA79895),
          error: const Color(0xFFD76767),
          onError: const Color(0xFFFFDEDE),
          surface: const Color(0xFFFAF2EB),
          onSurface: const Color(0xFF3E301D),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: const FolderListScreen(),
    );
  }
}
