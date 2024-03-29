import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: BurgerKingReservationPage(),
    );
  }
}

class BurgerKingReservationPage extends StatefulWidget {
  @override
  _BurgerKingReservationPageState createState() => _BurgerKingReservationPageState();
}

class _BurgerKingReservationPageState extends State<BurgerKingReservationPage> {
  int _availableSlots = 10; // Número inicial de vagas disponíveis

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva de Vagas - Burger King'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vagas Disponíveis: $_availableSlots',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _availableSlots,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Vaga ${index + 1}'),
                    onTap: () {
                      _reserveSlot();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reserveSlot() {
    if (_availableSlots > 0) {
      setState(() {
        _availableSlots--; // Diminui o número de vagas disponíveis ao fazer a reserva
      });
      // Aqui você pode adicionar a lógica para realizar a reserva, como enviar uma solicitação para um servidor, etc.
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sem Vagas Disponíveis'),
            content: Text('Todas as vagas já foram reservadas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
