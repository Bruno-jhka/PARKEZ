import 'package:flutter/material.dart';

class BKPageReserve extends StatelessWidget {
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
              'img/estabelecimentos/lojabk.jpg',
              height: 200, // Ajuste a altura conforme necessário
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Nome do lugar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Burguer King - Castelo',
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
                'Endereço: Av. Heráclito Mourão de Miranda, 800 - Alípio de Melo, Belo Horizonte - MG, 30840-032',
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
                'Rede de fast-food famosa com hambúrgueres grelhados, batata frita e milk-shakes.',
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
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Quantidade de vagas disponíveis
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Vagas disponíveis: 7',
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
                 Navigator.pushNamed(context, '/pagamentos');
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
