import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:parkez/_Comum/Snackbar.dart';
import 'package:parkez/servicos/autenticacao_servico.dart';
import 'package:parkez/servicos/informacoes_user_servicos.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() {
    return RegisterPageState();
  }
}

TextEditingController _emailController = TextEditingController();
TextEditingController _senhaController = TextEditingController();
TextEditingController _nomeController = TextEditingController();

AutenticacaoServicos _autenServicos = AutenticacaoServicos();
final UserInformationService _userInformationService = UserInformationService();

class RegisterPageState extends State<RegisterPage> {
  bool _obscureText = true;
  String email = '';
  String nome = '';
  String password = '';
  String confirmPassword = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
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
            /*Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: _nomeController,
                onChanged: (text) {
                  nome = text;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'nome',
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
            ),*/
            SizedBox(height: 10),
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
                      _obscureText ? Icons.visibility : Icons.visibility_off,
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
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                onChanged: (text) {
                  confirmPassword = text;
                },
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
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
                        if (password == confirmPassword) {
                          // Perform registration action

                          print(
                              "${_emailController.text}, ${_senhaController.text})");
                          _autenServicos
                              .cadastrarUsuario(
                            email: _emailController.text,
                            senha: _senhaController.text,
                            //nome: _nomeController.text
                          )
                              .then(
                            (String? erro) {
                              if (erro != null) {
                                //voltou com erro
                                mostrarSnackBar(context: context, texto: erro);
                              } else {
                                //deu certo
                                mostrarSnackBar(
                                  context: context,
                                  texto: "Cadastro efetuado com sucesso!",
                                  isErro: false,
                                );
                                Future.delayed(Duration(seconds: 4), () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/login');
                                });
                              }
                            },
                          );
                        } else {
                          setState(() {
                            mostrarSnackBar(
                                context: context,
                                texto: 'As senhas devem ser iguais');
                          });
                        }
                      },
                      child: Text(
                        'Registrar',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Text(
                          'Já tem uma conta? Entre aqui',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
