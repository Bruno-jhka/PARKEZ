import 'package:flutter/material.dart';
import 'package:parkez/servicos/autenticacao_servico.dart';
import 'package:parkez/_Comum/Snackbar.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AutenticacaoServicos _autenServicos = AutenticacaoServicos();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _autenServicos
                    .redefinirSenha(_emailController.text)
                    .then((String? erro) {
                  if (erro != null) {
                    mostrarSnackBar(context: context, texto: erro);
                  } else {
                    mostrarSnackBar(
                        context: context,
                        texto: 'Email de redefinição enviado com sucesso.',
                        isErro: false);
                    Navigator.of(context).pop();
                  }
                });
              },
              child: Text('Redefinir Senha'),
            ),
            errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
