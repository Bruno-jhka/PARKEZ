import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferências',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    AppController.instance.isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny,
                    color: AppController.instance.isDarkTheme ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(AppController.instance.isDarkTheme ? 'Modo Escuro' : 'Modo Claro'),
                  Expanded(child: Container()),
                  Switch(
                    value: AppController.instance.isDarkTheme,
                    onChanged: (value) {
                      AppController.instance.changeTheme();
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Notificações'),
              trailing: Switch(
                value: false, // Adicione o valor correto aqui
                onChanged: (value) {
                  // Implemente a lógica para controlar as notificações
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Idioma'),
              onTap: () {
                // Implemente a navegação para a seleção de idioma
              },
            ),
            Divider(),
            // Adicione mais configurações conforme necessário
          ],
        ),
      ),
    );
  }
}
