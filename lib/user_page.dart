import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icon_badge/icon_badge.dart';
import 'dart:convert';
import 'package:parkez/_Comum/info_user.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/controllers/notify_controller.dart';
import 'package:parkez/servicos/autenticacao_servico.dart';
import 'package:parkez/servicos/informacoes_user_servicos.dart';
import 'package:provider/provider.dart';
import '_Comum/int_state.dart';
import 'card_payment_page.dart'; // Import the CardPaymentPage

bool isCarregando = false;
final AutenticacaoServicos _autenServicos = AutenticacaoServicos();
final UserInformationService _userInformationService = UserInformationService();

final _formKey = GlobalKey<FormState>();

final TextEditingController _nomeController = TextEditingController();
final TextEditingController _telefoneController = TextEditingController();
final TextEditingController _cepController = TextEditingController();
final TextEditingController _ruaController = TextEditingController();
final TextEditingController _numCasaController = TextEditingController();
final TextEditingController _bairroController = TextEditingController();
final TextEditingController _cidadeController = TextEditingController();
final TextEditingController _estadoController = TextEditingController();

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Usuário'),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final intState = Provider.of<IntState>(context);
    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;
    var buttonColor =
        isDarkMode ? Color.fromARGB(255, 36, 36, 36) : Colors.white;
    var shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.grey.withOpacity(0.5);
    var textColor = isDarkMode
        ? Color.fromARGB(137, 255, 255, 255)
        : Color.fromARGB(137, 0, 0, 0);
    var backgroundColor = isDarkMode ? Color(0xFF1F1F1F) : Colors.white;

    return StreamBuilder<InfoUser?>(
      stream: _userInformationService.conectarStreamInfoUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar informações do usuário'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Verifica o estado atual antes de chamar setToOne
          if (intState.value != 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              intState.setToOne();
            });
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                _showCompleteAccountDialog(context);
              },
              child: Text('Completar Conta'),
            ),
          );
        }

        InfoUser userInfo = snapshot.data!;
        // Verifica o estado atual antes de chamar setToZero
        if (intState.value != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            intState.setToZero();
          });
        }

        return Column(
          children: [
            SizedBox(height: 20), // Adding some spacing

            SizedBox(height: 10),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: buttonColor,
                  ),
                  icon: Icon(Icons.map),
                  label: Text("Editar Conta"),
                  onPressed: () {
                    _showCompleteAccountDialog(context, userInfo);
                  },
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  ListTile(
                    title: Text('Nome'),
                    subtitle: Text(userInfo.nome),
                    leading: Icon(Icons.person),
                  ),
                  ListTile(
                    title: Text('Email'),
                    subtitle:
                        Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                    leading: Icon(Icons.email),
                  ),
                  ListTile(
                    title: Text('Telefone'),
                    subtitle: Text(userInfo.telefone),
                    leading: Icon(Icons.phone),
                  ),
                  ListTile(
                    title: Text('Endereço'),
                    subtitle: Text(
                        '${userInfo.rua}, ${userInfo.numCasa}, ${userInfo.bairro}, ${userInfo.cidade}, ${userInfo.estado}'),
                    leading: Icon(Icons.location_on),
                  ),
                  /*ListTile(
                    title: Text('Configurações de Notificação'),
                    subtitle: Text('Ativar/Desativar notificações'),
                    leading: Icon(Icons.notifications),
                    trailing: NotificationSwitch(),
                  ),
                  ListTile(
                    title: Text('Preferências de Tema'),
                    subtitle: Text('Alterar o tema do aplicativo'),
                    leading: Icon(Icons.color_lens),
                    trailing: ThemeSwitch(),
                  ),*/
                  ListTile(
                    title: Text('Deslogar'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      _autenServicos.deslogar();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                  ListTile(
                    title: Text('Carteira'),
                    leading: Icon(Icons.wallet),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CardPaymentPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final intState = Provider.of<IntState>(context);
    return Container(
      height: 45,
      color:
          AppController.instance.isDarkTheme ? Colors.grey[950] : Colors.white,
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
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implemente a navegação para a tela de Pesquisa
                Navigator.pushReplacementNamed(context, '/search');
              },
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
                //Navigator.of(context).pushReplacementNamed('/user');
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/settings');
                // Implemente a navegação para a tela de Configurações
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCompleteAccountDialog(BuildContext context, [InfoUser? userInfo]) {
    if (userInfo != null) {
      _nomeController.text = userInfo.nome;
      _telefoneController.text = userInfo.telefone;
      _cepController.text = userInfo.cep;
      _ruaController.text = userInfo.rua;
      _numCasaController.text = userInfo.numCasa;
      _bairroController.text = userInfo.bairro;
      _cidadeController.text = userInfo.cidade;
      _estadoController.text = userInfo.estado;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CompleteAccountDialog(userInfo: userInfo);
      },
    );
  }
}

class CompleteAccountDialog extends StatefulWidget {
  final InfoUser? userInfo;

  CompleteAccountDialog({this.userInfo});

  @override
  _CompleteAccountDialogState createState() => _CompleteAccountDialogState();
}

class _CompleteAccountDialogState extends State<CompleteAccountDialog> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;
    var buttonColor =
        isDarkMode ? Color(0xFF242424) : Colors.white; // Cor dos botões
    var textColor =
        isDarkMode ? Colors.white : Colors.black; // Cor do texto dos botões
    var backgroundColor = isDarkMode
        ? Color(0xFF1F1F1F)
        : Colors.white; // Cor do fundo do diálogo
    var shadowColor = Colors.black.withOpacity(0.5); // Cor da sombra
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text(
        'Completar Conta',
        style: TextStyle(color: textColor),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cepController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'CEP',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu CEP';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 8) {
                    _buscarEndereco(value);
                  }
                },
              ),
              TextFormField(
                controller: _ruaController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Rua',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua rua';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numCasaController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Número da Casa',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número da casa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bairroController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Bairro',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu bairro';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cidadeController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Cidade',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua cidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _estadoController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: TextStyle(color: textColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu estado';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            _limparCampos();
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: buttonColor),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            elevation: MaterialStateProperty.all<double>(5.0),
          ),
          child: Text(
            'Cancelar',
            style: TextStyle(color: textColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              enviarClicado(widget.userInfo);
              _limparCampos();
              Navigator.of(context).pop();
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: buttonColor),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
            elevation: MaterialStateProperty.all<double>(5.0),
          ),
          child: Text(
            'Salvar',
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }

  void enviarClicado(InfoUser? userInfo) {
    setState(() {
      isCarregando = true;
    });

    String? id = FirebaseAuth.instance.currentUser?.uid;
    String nome = _nomeController.text;
    String telefone = _telefoneController.text;
    String cep = _cepController.text;
    String rua = _ruaController.text;
    String numCasa = _numCasaController.text;
    String bairro = _bairroController.text;
    String cidade = _cidadeController.text;
    String estado = _estadoController.text;

    InfoUser infoUser = InfoUser(
      id: id,
      nome: nome,
      telefone: telefone,
      cep: cep,
      rua: rua,
      numCasa: numCasa,
      bairro: bairro,
      cidade: cidade,
      estado: estado,
    );

    _userInformationService.adicionarUserInfo(infoUser).then((value) {
      setState(() {
        isCarregando = false;
      });
    });
  }

  void _buscarEndereco(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _ruaController.text = data['logradouro'];
        _bairroController.text = data['bairro'];
        _cidadeController.text = data['localidade'];
        _estadoController.text = data['uf'];
      });
    } else {
      throw Exception('Erro ao buscar endereço');
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _telefoneController.clear();
    _cepController.clear();
    _ruaController.clear();
    _numCasaController.clear();
    _bairroController.clear();
    _cidadeController.clear();
    _estadoController.clear();
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
