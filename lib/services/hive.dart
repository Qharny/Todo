import 'package:hive/hive.dart';

class HiveService {
  static Box get taskBox => Hive.box('tasks');
  static Box get categoryBox => Hive.box('categories');
  static Box get settingsBox => Hive.box('settings');

  // Task operations
  static Future<void> addTask(Map<String, dynamic> task) async {
    await taskBox.add(task);
  }

  static Future<void> updateTask(int index, Map<String, dynamic> task) async {
    await taskBox.putAt(index, task);
  }

  static Future<void> deleteTask(int index) async {
    await taskBox.deleteAt(index);
  }

  // Settings operations
  static Future<void> toggleDarkMode() async {
    final bool currentMode = settingsBox.get('darkMode', defaultValue: false);
    await settingsBox.put('darkMode', !currentMode);
  }

  static Future<void> setSetting(String key, dynamic value) async {
    await settingsBox.put(key, value);
  }

  static dynamic getSetting(String key, {dynamic defaultValue}) {
    return settingsBox.get(key, defaultValue: defaultValue);
  }

  // Cleanup method
  static Future<void> clearAllData() async {
    await taskBox.clear();
    await categoryBox.clear();
    // Don't clear settings box as it contains user preferences
  }
}