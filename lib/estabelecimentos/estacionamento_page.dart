import 'package:flutter/material.dart';

class EstacionamentoPageReserve extends StatelessWidget {
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
              'img/estabelecimentos/estacionamento.jpg',
              height: 200, // Ajuste a altura conforme necessário
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Nome do lugar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Estacionamento Mineirão',
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
                'Endereço: Av. Antônio Abrahão Caram, 1001 - São José, Belo Horizonte - MG, 31275-000',
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
                'O Estacionamento Mineirão oferece uma localização conveniente e segura para os visitantes que desejam estacionar próximo ao Estádio Mineirão. Com uma infraestrutura moderna e atendimento dedicado, o estacionamento proporciona tranquilidade aos motoristas durante eventos esportivos, shows e outras atividades realizadas no entorno do estádio.',
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
