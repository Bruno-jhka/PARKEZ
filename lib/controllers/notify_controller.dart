import 'package:flutter/material.dart';
import 'package:parkez/servicos/informacoes_user_servicos.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserInformationService _userInformationService = UserInformationService();

class NotiController extends ChangeNotifier {
  static final NotiController _instance = NotiController._internal();
  factory NotiController() => _instance;

  NotiController._internal() {
    _loadNotificationPreferences();
  }

  static NotiController get instance => _instance;

  bool _notiEneable = false;

  bool get notiEneable => _notiEneable;

  Future<void> _loadNotificationPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notiEneable = prefs.getBool('notiEneable') ?? false;
    notifyListeners();
  }

  Future<void> setNoti(bool isNoti) async {
    _notiEneable = isNoti;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notiEneable', isNoti);
  }
}
