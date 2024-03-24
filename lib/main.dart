import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';
import 'package:parkez/home_page.dart';
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
            '/home':(context) => HomePage()
          },
        );
      },
    );
  }
}
