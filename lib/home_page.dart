import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:parkez/estabelecimentos/EstacionamentoPageReserve.dart';
import 'package:provider/provider.dart';
import '_Comum/int_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null && user.uid == "0vbAicu1G3hCzdOLbcUWvnffcNI3") {
            Future.microtask(
                () => Navigator.pushReplacementNamed(context, '/home_admin'));
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Image.asset(
                'img/Logo2.png',
                width: 300,
                height: 100,
              ),
            ),
          ),
          body: _buildBody(context),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    final intState = Provider.of<IntState>(context);
    final User? user = FirebaseAuth.instance.currentUser;

    return Expanded(
      child: SingleChildScrollView(
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
              height: 20,
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Usuarios')
                  .doc(user!.uid)
                  .collection('vagas')
                  .orderBy('expirationTime', descending: true)
                  .limit(4)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                var reservations = snapshot.data!.docs;
                // Filtra reservas duplicadas
                var uniqueReservations = <String, QueryDocumentSnapshot>{};
                for (var reservation in reservations) {
                  var data = reservation.data() as Map<String, dynamic>;
                  String estabelecimentoId = data['estabelecimentoId'];
                  if (!uniqueReservations.containsKey(estabelecimentoId)) {
                    uniqueReservations[estabelecimentoId] = reservation;
                  }
                }

                return Column(
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 5.0), // Adiciona padding lateral
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children:
                              uniqueReservations.values.map((reservation) {
                            var data =
                                reservation.data() as Map<String, dynamic>;
                            String estabelecimentoId =
                                data['estabelecimentoId'];

                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('estabelecimentos')
                                  .doc(estabelecimentoId)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                var estabelecimentoData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                String? imageUrl =
                                    estabelecimentoData['imageUrl'];
                                String? nomeEstabelecimento =
                                    estabelecimentoData['nome'];

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PagEstabelecimentoReserve(
                                                estabelecimentoId:
                                                    estabelecimentoId),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 85,
                                    height: 85,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              const Color.fromARGB(255, 0, 0, 0)
                                                  .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(2,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          imageUrl != null
                                              ? Image.network(
                                                  imageUrl,
                                                  width: 85,
                                                  height: 85,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(Icons.image,
                                                  size: 85,
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0)),
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: 85,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                  12)),
                                                  color: Colors.black54,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 4.0,
                                                    vertical: 2.0),
                                                child: Text(
                                                  nomeEstabelecimento ?? '',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 40),
            Text(
              'Sugestões',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('estabelecimentos')
                  .limit(16) // Limitado a 16 sugestões (4 linhas de 4)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                var suggestions = snapshot.data!.docs;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 imagens por linha
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio:
                          1.0, // Aspect ratio 1:1 para imagens quadradas
                    ),
                    itemCount: suggestions.length,
                    itemBuilder: (context, index) {
                      var data =
                          suggestions[index].data() as Map<String, dynamic>;
                      String? imageUrl = data['imageUrl'];
                      String? nomeEstabelecimento = data['nome'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PagEstabelecimentoReserve(
                                  estabelecimentoId: data['nome']),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset:
                                    Offset(2, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    imageUrl ??
                                        'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(12)),
                                        color: Colors.black54,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0),
                                      child: Text(
                                        nomeEstabelecimento ?? '',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
                height:
                    80), // Altura para ajustar o espaço abaixo do conteúdo rolável
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final intState = Provider.of<IntState>(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppController.instance.isDarkTheme
            ? Color.fromARGB(0, 33, 33, 33)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/search');
            },
          ),
          IconBadge(
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
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
