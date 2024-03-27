import 'package:flutter/material.dart';
import 'package:parkez/app_Controller.dart';
import 'package:parkez/login_page.dart';
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
        // Adicionando o ícone do menu de hambúrguer
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: _buildBody(),
     // Drawer para o menu de hambúrguer:
drawer: Drawer(
  child: Column(
    children: <Widget>[
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Usuário',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user');
              },
            ),
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                // Ação quando "Configurações" é selecionado
                Navigator.pop(context); // Fecha o Drawer
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    ],
  ),
),
    );
  }

Widget _buildBody() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Novidades Parkez!',
        style: TextStyle(fontSize: 24),
      ),
      Expanded(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CarouselSlider(
                items: [
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1nFeVHvCJ7mWSCMe-JKZKZbYMp6QVBK0zDw&usqp=CAU'),
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxNPyk-rK2tpmdsBec0_w8DeMEmpgXC6QDow&usqp=CAU'),
                  Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdFv4DRXP5uVM0V1O-HhAHps7n0PaH4cfvAA&usqp=CAU'),
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
            Container(
              color: AppController.instance.isDarkTheme ? Colors.grey[900] : Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 200), // Espaçamento entre a barra de pesquisa e as sugestões
            Text(
              'Sugestões:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10), // Espaçamento entre o texto "Sugestões:" e as imagens
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Image.asset('img/coreuburguer.jpg', 
                  width: 50, 
                  height: 80,),
                ),
                SizedBox(width: 10), // Espaçamento entre as imagens
                Expanded(
                  child: Image.asset('img/pizzaria.jpg',
                  width: 50, 
                  height: 80,),
                ),
                SizedBox(width: 10), // Espaçamento entre as imagens
                Expanded(
                  child: Image.asset('img/sushi.jpg',
                  width: 50, 
                  height: 80,),
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 45,
              color: AppController.instance.isDarkTheme ? Colors.grey[900] : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.home),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
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



}
