import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends ChangeNotifier {
  static final AppController _instance = AppController._internal();
  factory AppController() => _instance;

  AppController._internal() {
    _loadThemeAndPreferences();
  }

  static AppController get instance => _instance;

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  get themeData => _isDarkTheme;

  Future<void> _loadThemeAndPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkTheme = isDark;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }

  void changeTheme() {
    setTheme(!_isDarkTheme);
  }
}
