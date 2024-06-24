import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parkez/estabelecimentos/EstacionamentoPageReserve.dart';
import 'package:provider/provider.dart';
import '_Comum/int_state.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'img/Logo2.png',
            width: 300, // Ajuste o tamanho conforme necessário
            height: 100, // Ajuste o tamanho conforme necessário
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final intState = Provider.of<IntState>(context);
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
              SizedBox(
                height: 40,
              ), // Espaçamento entre o carrossel e o botão
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Administração de Estabelecimentos',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Centraliza o texto
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/estabelecimentos/admVaga');
                      },
                      icon: Icon(Icons.add),
                      label: Text('Criar Novo Estabelecimento'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40), // Espaçamento entre a seção e as sugestões
              Text(
                'Sugestões',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              SizedBox(
                  height:
                      10), // Espaçamento entre o texto "Sugestões:" e as imagens
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/coreuburguer.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit
                              .cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/pizzaria.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit
                              .cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Define o raio das bordas
                        child: Image.asset(
                          'img/sugestoes/sushi.jpg',
                          width: 200, // Ajuste o tamanho conforme necessário
                          height: 100, // Ajuste o tamanho conforme necessário
                          fit: BoxFit
                              .cover, // Ajusta a imagem para preencher o espaço disponível
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 45,
                color: AppController.instance.isDarkTheme
                    ? Colors.grey[950]
                    : Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.home),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/search');
                            // Implemente a navegação para a tela de Pesquisa
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconBadge(
                          icon: Icon(Icons.account_circle),
                          itemCount: intState.value,
                          right: 17,
                          badgeColor: Colors.red,
                          itemColor: Colors.white,
                          hideZero: true,
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/user');
                            print('test');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.settings),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/settings');
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
