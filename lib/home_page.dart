import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';
import 'package:parkez/login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar customizations would go here
        title: Text('Bem-vindo ao Parkez'),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Seja bem-vindo ao Parkez!',
              style: TextStyle(fontSize: 24),
            ),
            // You can add more widgets here for additional content
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.all(90.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppController.instance.isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
            color: AppController.instance.isDarkTheme ? Colors.white : Colors.black,
          ),
          SizedBox(width: 8), // Adiciona um espaçamento entre o ícone e o CustomSwitch
          CustomSwitch(),
        ],
      ),
    );
  }
}
