import 'package:flutter/material.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:icon_badge/icon_badge.dart';

class testePage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<testePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 45,
        color: AppController.instance.isDarkTheme
            ? Colors.white
            : Colors.grey[950],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/homeS');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Implemente a navegação para a tela de Pesquisa
                  Navigator.pushReplacementNamed(context, '/searchS');
                },
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  IconBadge(
                    icon: Icon(Icons.account_circle),
                    itemCount: 1,
                    badgeColor: Colors.red,
                    itemColor: Color.fromARGB(255, 255, 213, 0),
                    hideZero: true,
                    onTap: () {
                      print('test');
                    },
                  ),
                  /*Positioned(
                    right: 0,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '1', // Valor desejado para a notificação
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/settingsS');
                  // Implemente a navegação para a tela de Configurações
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
