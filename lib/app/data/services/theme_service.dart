import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // Always return dark theme by default
  ThemeMode get theme => ThemeMode.dark;

  bool _loadThemeFromBox() => _box.read<bool>(_key) ?? true;

  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    // Always keep dark mode
    Get.changeThemeMode(ThemeMode.dark);
    _saveThemeToBox(true);
  }
}
