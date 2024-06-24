import 'package:flutter/material.dart';
import 'package:parkez/_Comum/Snackbar.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/servicos/autenticacao_servico.dart';
import 'package:parkez/page_esqueceu_senha.dart'; // Importe a página de redefinição de senha

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() {
    return LoginPageState();
  }
}

TextEditingController _emailController = TextEditingController();
TextEditingController _senhaController = TextEditingController();
TextEditingController _nomeController = TextEditingController();

AutenticacaoServicos _autenServicos = AutenticacaoServicos();

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
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Customizações do AppBar
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'img/Logo.png',
              width: 100,
              height: 100,
            ),
            Image.asset(
              'img/Logo2.png',
              width: 300,
              height: 100,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: _emailController,
                onChanged: (text) {
                  email = text;
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
                    controller: _senhaController,
                    onChanged: (text) {
                      password = text;
                    },
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
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
                : SizedBox(),
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
                        _autenServicos
                            .logarUsuario(
                                email: _emailController.text,
                                senha: _senhaController.text)
                            .then((String? erro) {
                          if (erro != null) {
                            mostrarSnackBar(context: context, texto: erro);
                          } else {
                            _emailController.clear();
                            _senhaController.clear();
                            email = '';
                            password = '';
                            Navigator.of(context).pushReplacementNamed('/home');
                          }
                        });
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()));
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
            AppController.instance.isDarkTheme
                ? Icons.nightlight_round
                : Icons.wb_sunny,
            color: AppController.instance.isDarkTheme
                ? Colors.white
                : Colors.black,
          ),
          SizedBox(width: 8),
          CustomSwitch(),
        ],
      ),
    );
  }
}
