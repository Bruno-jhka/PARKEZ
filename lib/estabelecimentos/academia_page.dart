import 'package:flutter/material.dart';

class PratiquePageReserve extends StatelessWidget {
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
              'img/estabelecimentos/pratique.jpg',
              height: 200, // Ajuste a altura conforme necessário
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Nome do lugar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Pratique Academia',
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
                'Endereço: Av. do Contorno, 7655 - Lourdes, Belo Horizonte - MG, 30110-090, Brasil',
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
                  'Pratique Academia oferece uma ampla variedade de equipamentos de alta qualidade e programas de treinamento personalizados para ajudar os clientes a atingirem seus objetivos de condicionamento físico. Com instrutores qualificados e um ambiente acolhedor, a Pratique Academia é o lugar ideal para quem busca uma rotina de exercícios eficaz e motivadora.',
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
                'Vagas disponíveis: 15',
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
