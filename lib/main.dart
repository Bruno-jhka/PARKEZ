import 'package:flutter/material.dart';
import 'package:parkez/about_page.dart';
import 'package:parkez/app_Controller.dart';
import 'package:parkez/estabelecimentos/academia_page.dart';
import 'package:parkez/estabelecimentos/bk_page.dart';
import 'package:parkez/estabelecimentos/estacionamento_Page.dart';
import 'package:parkez/estabelecimentos/shopping_page.dart';
import 'package:parkez/home_page.dart';
import 'package:parkez/search_page.dart';
import 'package:parkez/setting_page.dart';
import 'package:parkez/singup_page.dart';
import 'package:parkez/user_page.dart';
import 'login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Parkez',
          theme: ThemeData(
            primaryColor: Colors.black,
            hintColor: Colors.amber,
            brightness: AppController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/':(context) => LoginPage(),
            '/home':(context) => HomePage(),
            '/user':(context) => ProfilePage(),
            '/settings':(context) => SettingsPage(),
            '/about':(context) => AboutPage(),
            '/search':(context) => SearchPage(),
            '/signup':(context) => RegisterPage(),
            '/estabelecimentos/bk': (context) => BKPageReserve(),
            '/estabelecimentos/estacionamento':(context) => EstacionamentoPageReserve(),
            '/estabelecimentos/pratique':(context) => PratiquePageReserve(),
            '/estabelecimentos/shopping':(context) => ShoppingPageReserve()
          },
        );
      },
    );
  }
}
