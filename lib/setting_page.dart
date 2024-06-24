import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/controllers/notify_controller.dart';
import 'package:parkez/servicos/autenticacao_servico.dart';
import 'package:parkez/servicos/informacoes_user_servicos.dart';
import 'package:provider/provider.dart';
import '_Comum/int_state.dart';

final AutenticacaoServicos _autenServicos = AutenticacaoServicos();
final UserInformationService _userInformationService = UserInformationService();

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final intState = Provider.of<IntState>(context);
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
                    AppController.instance.isDarkTheme
                        ? Icons.nightlight_round
                        : Icons.wb_sunny,
                    color: AppController.instance.isDarkTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(AppController.instance.isDarkTheme
                      ? 'Modo Escuro'
                      : 'Modo Claro'),
                ],
              ),
              trailing: ThemeSwitch(),
            ),
            Divider(),
            ListTile(
              title: Text('Notificações'),
              leading: Icon(Icons.notifications),
              trailing: NotificationSwitch(),
            ),
            Divider(),
            ListTile(
              title: Text('Idioma'),
              onTap: () {
                // Implemente a navegação para a seleção de idioma
              },
            ),
            Divider(),
            ListTile(
              title: Text('Sobre o App'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            Divider(),
            ListTile(
              title: Text('Deslogar'),
              leading: Icon(Icons.logout),
              onTap: () {
                _autenServicos.deslogar();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            Divider(),
            // Adicione mais configurações conforme necessário
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 45,
        color: AppController.instance.isDarkTheme
            ? Colors.grey[950]
            : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/search');
                    // Implemente a navegação para a tela de Configurações
                  },
                ),
              ),
            ),
            Expanded(
              child: IconBadge(
                icon: Icon(Icons.account_circle),
                itemCount: intState.value,
                right: 17,
                badgeColor: Colors.red,
                itemColor: Colors.white,
                hideZero: true,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/user');
                  print('test');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool _notiEneable = NotiController.instance.notiEneable;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _notiEneable,
      onChanged: (value) {
        setState(() {
          _notiEneable = value;
          NotiController.instance.setNoti(_notiEneable);
        });
      },
    );
  }
}

class ThemeSwitch extends StatefulWidget {
  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  bool _isDarkTheme = AppController.instance.isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isDarkTheme,
      onChanged: (value) {
        setState(() {
          _isDarkTheme = value;
          AppController.instance.setTheme(_isDarkTheme);
        });
      },
    );
  }
}
