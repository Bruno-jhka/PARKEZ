import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Seu Perfil',
          style: TextStyle(fontSize: 24),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              ListTile(
                title: Text('Nome do Usuário'),
                subtitle: Text('Seu nome de usuário aqui'),
                leading: Icon(Icons.person),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text('seuemail@example.com'),
                leading: Icon(Icons.email),
              ),
              ListTile(
                title: Text('Telefone'),
                subtitle: Text('(00) 12345-6789'),
                leading: Icon(Icons.phone),
              ),
              ListTile(
                title: Text('Endereço'),
                subtitle: Text('Sua rua, nº, bairro, cidade, estado'),
                leading: Icon(Icons.location_on),
              ),
              ListTile(
                title: Text('Configurações de Notificação'),
                subtitle: Text('Ativar/Desativar notificações'),
                leading: Icon(Icons.notifications),
                trailing: Switch(
                  value: true, // Altere para o valor real do estado de notificação
                  onChanged: (value) {
                    // Implemente a lógica para alterar o estado de notificação
                  },
                ),
              ),
              ListTile(
                title: Text('Preferências de Tema'),
                subtitle: Text('Alterar o tema do aplicativo'),
                leading: Icon(Icons.color_lens),
                onTap: () {
                  // Implemente a navegação para a tela de configurações de tema
                },
              ),
            ],
          ),
        ),
        Spacer(),
              Container(
                height: 45,
                color: AppController.instance.isDarkTheme ? Colors.grey[950] : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                        ),
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
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.account_circle),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/user');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/settings');
                            // Implemente a navegação para a tela de Configurações
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
