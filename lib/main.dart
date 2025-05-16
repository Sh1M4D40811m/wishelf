import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishelf/services/initialize_app.dart';
import 'viewmodels/folder_view_model.dart';
import 'package:wishelf/views/folder_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FolderViewModel()..loadFolders(),
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
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF624A2E),
          onPrimary: const Color(0xFFDBD0C7),
          secondary: Colors.green,
          onSecondary: Colors.purple,
          error: const Color(0xFFD76767),
          onError: const Color(0xFFFFDEDE),
          surface: const Color(0xFFFAF2EB),
          onSurface: const Color(0xFF442C2D),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: const FolderListScreen(),
    );
  }
}
