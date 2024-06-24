import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:parkez/card_payment_page.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/servicos/vagas_user_servico.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:parkez/servicos/Database_card.dart'; // Importe o banco de dados local
import 'package:flutter/services.dart';

class PagEstabelecimentoReserve extends StatefulWidget {
  final String estabelecimentoId;

  PagEstabelecimentoReserve({required this.estabelecimentoId});

  @override
  _PagEstabelecimentoReserveState createState() =>
      _PagEstabelecimentoReserveState();
}

class _PagEstabelecimentoReserveState extends State<PagEstabelecimentoReserve> {
  int vagasDisponiveis = 0;
  String endereco = '';
  String endereco2 = '';
  String numero = '';
  String nome = '';
  String descricao = '';
  String imageUrl = '';
  String preco = "0.0";
  Timer? _timer;
  Duration _timeRemaining = Duration();

  get boxShadow => null;

  @override
  void initState() {
    super.initState();
    _fetchEstabelecimentoInfo();
    _checkActiveReservation();
  }

  Future<void> _fetchEstabelecimentoInfo() async {
    var doc = await FirebaseFirestore.instance
        .collection('estabelecimentos')
        .doc(widget.estabelecimentoId)
        .get();
    setState(() {
      vagasDisponiveis = doc['vagas'];
      endereco2 = doc['endereco'];
      numero = doc['numero'];
      endereco = "$endereco2, $numero";
      nome = doc['nome'];
      descricao = doc['descricao'];
      imageUrl = doc['imageUrl'];
      preco = doc['preco']
          .toString()
          .replaceAll(',', '.'); // Garantindo ponto como separador decimal
    });
  }

  Future<void> _checkActiveReservation() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var uid = user.uid;
      var now = DateTime.now();
      var firestore = FirebaseFirestore.instance;
      var userReservations = await firestore
          .collection('Usuarios')
          .doc(uid)
          .collection('vagas')
          .where('expirationTime', isGreaterThan: now.toIso8601String())
          .get();
      if (userReservations.docs.isNotEmpty) {
        var reservation = userReservations.docs.first;
        var expirationTime = DateTime.parse(reservation['expirationTime']);
        setState(() {
          _timeRemaining = expirationTime.difference(now);
        });
        _startTimer(expirationTime);
      }
    }
  }

  void _startTimer(DateTime expirationTime) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var now = DateTime.now();
      if (now.isBefore(expirationTime)) {
        setState(() {
          _timeRemaining = expirationTime.difference(now);
        });
      } else {
        timer.cancel();
        setState(() {
          _timeRemaining = Duration();
        });
        // Aqui você pode adicionar lógica para lidar com a reserva expirada, se necessário
      }
    });
  }

  Future<void> _reservarVaga(String duration, String price) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var uid = user.uid;
      var durationInMinutes =
          double.parse(duration) * 60; // Converter horas para minutos
      var expirationTime =
          DateTime.now().add(Duration(minutes: durationInMinutes.toInt()));
      await ReservationManager.reserveSpot(
        uid: uid,
        estabelecimentoId: widget.estabelecimentoId,
        vagasDisponiveis: vagasDisponiveis,
        preco: price,
        duration: duration,
        expirationTime: expirationTime.toIso8601String(),
      );
      await _fetchEstabelecimentoInfo();
      await _checkActiveReservation();
    }
  }

  void _launchMaps() async {
    String query = Uri.encodeComponent(endereco);
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunchUrlString(googleMapsUrl)) {
      await launchUrlString(googleMapsUrl,
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  void _showPaymentOptions(String duration, String price) {
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

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          color: backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
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
                child: ListTile(
                  leading: Icon(Icons.qr_code, color: textColor),
                  title:
                      Text('Pagar com Pix', style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _processPixPayment(duration, price);
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
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
                child: ListTile(
                  leading: Icon(Icons.credit_card, color: textColor),
                  title: Text('Pagar com Cartão de Crédito',
                      style: TextStyle(color: textColor)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCardPaymentOptions(duration, price);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReservationDialog(double duration, String price) {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text("Confirmar Reserva", style: TextStyle(color: textColor)),
          content: Text(
            "Você está prestes a reservar uma vaga por $duration ao preço de R\$ $price. Deseja continuar?",
            style: TextStyle(color: textColor),
          ),
          actions: [
            Container(
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
              child: TextButton(
                child: Text("Cancelar", style: TextStyle(color: textColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
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
              child: TextButton(
                child: Text("Reservar", style: TextStyle(color: textColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showPaymentOptions(duration.toString(), price);
                },
              ),
            ),
          ],
          backgroundColor: buttonColor,
        );
      },
    );
  }

  void _showCardPaymentOptions(String duration, String price) {
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
    var accentColor = Color.fromARGB(255, 36, 25, 162);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            "Selecionar Cartão",
            style: TextStyle(color: textColor),
          ),
          content: FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper()
                .getCards(), // Método para obter os cartões do banco de dados local
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Erro ao carregar cartões.",
                    style: TextStyle(color: textColor));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("Nenhum cartão cadastrado.",
                    style: TextStyle(color: textColor));
              } else {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: snapshot.data!.map((card) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
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
                        child: ListTile(
                          title: Text(
                            card['nickname'] ?? 'Cartão sem apelido',
                            style: TextStyle(color: textColor),
                          ),
                          subtitle: Text(
                            '**** **** **** ${card['cardNumber'].substring(card['cardNumber'].length - 4)}',
                            style: TextStyle(color: textColor),
                          ),
                          leading: Icon(Icons.credit_card, color: accentColor),
                          trailing:
                              Icon(Icons.arrow_forward_ios, color: textColor),
                          onTap: () {
                            Navigator.of(context).pop();
                            _reservarVaga(duration, price);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                icon: Icon(Icons.add, color: textColor),
                label: Text("Adicionar Cartão",
                    style: TextStyle(color: textColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CardPaymentPage()),
                  );
                },
              ),
            ),
          ],
          backgroundColor: backgroundColor,
        );
      },
    );
  }

  void _processPixPayment(String duration, String price) {
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

    // Geração de um QR code dinâmico para pagamento com Pix
    String Chave =
        "00020126830014BR.GOV.BCB.PIX013689f5698f-1cd5-48c9-8703-4d894722f55f0221teste estabelecimento52040000530398654040.015802BR5925Bruno Henrique Freitas Ar6009SAO PAULO62140510LMogvwd32o6304CE4B";
    String pixCode =
        'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=00020126830014BR.GOV.BCB.PIX013689f5698f-1cd5-48c9-8703-4d894722f55f0221teste estabelecimento52040000530398654040.015802BR5925Bruno Henrique Freitas Ar6009SAO PAULO62140510LMogvwd32o6304CE4B';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            "Pagamento com Pix",
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Escaneie o QR code ou copie o código Pix.",
                style: TextStyle(color: textColor),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  child: Image.network(
                    pixCode,
                    height: 200,
                    width: 200,
                    fit: BoxFit
                        .contain, // Ajusta a imagem ao tamanho do container
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
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
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        child: Text("Copiar Código Pix",
                            style: TextStyle(color: textColor)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: Chave));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Código Pix copiado!")),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
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
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: textColor,
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text("Reservar Vaga",
                            style: TextStyle(color: textColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _reservarVaga(duration, price);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: buttonColor,
        );
      },
    );
  }

  double _calculatePrice(double durationInHours) {
    double pricePerHalfHour = double.tryParse(preco) ?? 0.0;
    return pricePerHalfHour * 2 * durationInHours;
  }

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Vaga'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 900,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Text('Erro ao carregar a imagem');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    endereco,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
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
                        label: Text("Ver no Mapa"),
                        onPressed: _launchMaps,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    descricao,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  if (_timeRemaining.inSeconds > 0)
                    Text(
                      'Reserva ativa: ${_formatDuration(_timeRemaining)}',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  SizedBox(height: 10),
                  if (_timeRemaining.inSeconds <= 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecione a duração da reserva:',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        _buildDurationButton('teste', 5),
                        _buildDurationButton('30 minutos', 0.5),
                        _buildDurationButton('1 hora', 1),
                        _buildDurationButton('2 horas', 2),
                        _buildDurationButton('3 horas', 3),
                        _buildDurationButton('4 horas', 4),
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

  String _formatDuration(Duration duration) {
    return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }

  Widget _buildDurationButton(String text, double durationInHours) {
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
    double price = _calculatePrice(durationInHours);
    return Center(
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
          //icon: Icon(Icons.map),
          label: Text('$text - R\$ ${price.toStringAsFixed(2)}'),
          onPressed: () =>
              _showReservationDialog(durationInHours, price.toStringAsFixed(2)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
