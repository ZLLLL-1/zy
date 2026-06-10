import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:lianliankan/utils/storage_util.dart';

class AppModel extends Model {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // 初始化主题
  Future<void> initTheme() async {
    bool? isDark = await StorageUtil.getBool('dark_mode');
    if (isDark == true) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  // 切换深色模式
  Future<void> toggleDarkMode(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    await StorageUtil.setBool('dark_mode', value);
    notifyListeners();
  }
}