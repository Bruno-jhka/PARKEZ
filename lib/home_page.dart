import 'dart:js';

import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'img/Logo2.png',
            width: 300, // Adjust the size as needed
            height: 100, // Adjust the size as needed
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: CarouselSlider(
                  items: [
                    Image.asset('img/carrosel/carrosel1.png'),
                    Image.asset('img/carrosel/carrosel2.png'),
                    Image.asset('img/carrosel/carrosel3.png'),
                  ],
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1,
                  ),
                ),
              ),
              SizedBox(height: 40), // Espaçamento entre a barra de pesquisa e as sugestões
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Últimas Reservas',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
               Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildCircularImage('img/historico/estacionamento.jpg'),
                      _buildCircularImage('img/historico/bk.png'),
                      _buildCircularImage('img/historico/shopping.png'),
                      _buildCircularImage('img/historico/pratique.jpg'),
                    ],
                  ),

                ],
              ),
              SizedBox(height: 40), // Espaçamento entre a barra de pesquisa e as sugestões
              Text(
                'Sugestões',
                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,),
                
              ),
              SizedBox(height: 10), // Espaçamento entre o texto "Sugestões:" e as imagens
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/coreuburguer.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit.cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/pizzaria.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit.cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/sushi.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit.cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 45,
                color: AppController.instance.isDarkTheme ? Colors.grey[950] : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {
                            
                          },
                        ),
                      ),
                    ),
                     Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/search');
                            // Implemente a navegação para a tela de Configurações
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.account_circle),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/user');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/settings');
                            // Implemente a navegação para a tela de Configurações
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildCircularImage(String imageUrl) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
