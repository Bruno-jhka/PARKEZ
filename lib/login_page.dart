import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() {
    return LoginPageState();
  }
}

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: AppController.instance.isDarkTheme, 
      onChanged: (value) {
        AppController.instance.changeTheme();
      },
    );
  }
}

class LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  String email = '';
  String password = '';
  String errorMessage = ''; // Variável para armazenar a mensagem de erro

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar customizations would go here
      ),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), 
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinha o conteúdo ao topo
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/Logo.png',
              width: 100, // Adjust the size as needed
              height: 100, // Adjust the size as needed
            ),
            Image.asset(
              'img/Logo2.png',
              width: 300, // Adjust the size as needed
              height: 100, // Adjust the size as needed
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                onChanged: (text){
                      email=text;
                    },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    onChanged: (text){
                      password=text;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(), // Se não houver mensagem de erro, exibe um SizedBox
            SizedBox(height: 30),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 15,
                children: [
                  Container(
                    width: 140,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (email == 'admin' && password == 'admin') {
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          setState(() {
                            errorMessage = 'Credenciais inválidas';
                          });
                        }
                      },
                      child: Text(
                        'Entrar',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).pushReplacementNamed('/signup');
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 30, 45, 187),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Adicione aqui a lógica para navegar para a tela de redefinição de senha
                        },
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
