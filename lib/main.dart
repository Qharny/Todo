import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo/screens/splash.dart';
import 'models/category.dart';
import 'models/task.dart';
import 'screens/home.dart';
import 'theme/theme.dart';



late SharedPreferences prefs;

void main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize SharedPreferences
    prefs = await SharedPreferences.getInstance();

    // Initialize Hive
    final appDocumentDirectory = 
        await path_provider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDirectory.path);

    // Register Hive Adapters
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(CategoryAdapter());

    // Open Hive Boxes
    await Hive.openBox('tasks');
    await Hive.openBox('categories');
    await Hive.openBox('settings');

    runApp(const Todo());
  } catch (e) {
    print('Error initializing app: $e');
    // You might want to show some error UI here
  }
}

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, Box settingsBox, child) {
        bool isDarkMode = settingsBox.get('darkMode', defaultValue: false);
        
        return MaterialApp(
          title: 'TaskMana',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: _SplashScreenWrapper(),
        );
      },
    );
  }
}

class _SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      onAnimationComplete: () {
        // Using Navigator.pushReplacement with the correct context
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }
}