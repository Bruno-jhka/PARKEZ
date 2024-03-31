import 'dart:math';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realizar Pagamento'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Escolha o método de pagamento:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showCardPaymentPopup(context);
                  },
                  child: Text('Pagar com Cartão'),
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showPixPaymentPopup(context);
                  },
                  child: Text('Pagar com PIX'),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Selecione uma opção de pagamento para prosseguir.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

void _showCardPaymentPopup(BuildContext context) {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cardHolderController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Preencher Dados do Cartão'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Número do Cartão'),
              ),
              TextField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Código de Segurança'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'Validade (MM/AA)'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cardHolderController,
                      decoration: InputDecoration(labelText: 'Nome do Titular'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _showSuccessMessage(context);
              Navigator.of(context).pop();
            },
            child: Text('Confirmar'),
          ),
        ],
      );
    },
  );
}



  void _showPixPaymentPopup(BuildContext context) {
    // Gera um QR code aleatório
    String randomQRCode = 'https://example.com/payment/${Random().nextInt(10000)}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code PIX'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escaneie o QR code abaixo para realizar o pagamento.'),
              SizedBox(height: 20),
              Image.network('https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$randomQRCode'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pagamento Realizado'),
          content: Text('Vaga garantida.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(),
  ));
}
