import 'package:flutter/material.dart';

class ShoppingPageReserve extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Vaga'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem do lugar
            Image.asset(
              'img/estabelecimentos/shopping.jpg',
              height: 200, // Ajuste a altura conforme necessário
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Nome do lugar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Shopping Contagem',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
              // Endereço
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Endereço: Av. Severino Ballesteros Rodrigues, 850 - Cabral, Contagem - MG, 32040-500, Brasil',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey
                ),
              ),
            ),
            SizedBox(height: 20),

           Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'O Shopping Contagem é um destino de compras e entretenimento que oferece uma variedade de lojas, desde marcas populares até boutiques exclusivas, além de uma ampla seleção de restaurantes e opções de lazer para toda a família.',
                style: TextStyle(
                fontSize: 16,
                ),
              ),
            ),

            SizedBox(height: 10),
            // Classificação de estrelas
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                  Icon(Icons.star_border, color: Colors.amber),

                ],
              ),
            ),
            SizedBox(height: 20),
            // Quantidade de vagas disponíveis
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Vagas disponíveis: 87',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Botão de reserva
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para reservar a vaga
                },
                child: Text('Reservar Vaga'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
