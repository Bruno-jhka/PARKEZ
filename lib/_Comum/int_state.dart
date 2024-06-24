import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntState with ChangeNotifier {
  int _value = 0;

  IntState() {
    _loadFromPrefs();
  }

  int get value => _value;

  void toggle() {
    _value = _value == 0 ? 1 : 0;
    _saveToPrefs();
    notifyListeners();
  }

  void setToOne() {
    _value = 1;
    _saveToPrefs();
    notifyListeners();
  }

  void setToZero() {
    _value = 0;
    _saveToPrefs();
    notifyListeners();
  }

  void _loadFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt('intStateValue') ?? 0;
    notifyListeners();
  }

  void _saveToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intStateValue', _value);
  }
}
