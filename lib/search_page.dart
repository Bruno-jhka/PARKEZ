import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/estabelecimentos/Admin_estabelecimentos/AdminPage_establecimentos.dart';
import 'package:parkez/estabelecimentos/EstacionamentoPageReserve.dart';
import 'package:provider/provider.dart';
import '_Comum/int_state.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final intState = Provider.of<IntState>(context);
    final brightness = Theme.of(context).brightness;
    final isDarkTheme = AppController.instance.isDarkTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDarkTheme ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: isDarkTheme
                        ? Colors.black.withOpacity(0.5)
                        : Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar estabelecimento',
                  hintStyle: TextStyle(
                    color: isDarkTheme
                        ? Color.fromARGB(137, 255, 255, 255)
                        : Color.fromARGB(137, 0, 0, 0),
                  ),
                  filled: true,
                  fillColor: isDarkTheme
                      ? Color.fromARGB(255, 36, 36, 36)
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: isDarkTheme ? Colors.white : Colors.black54),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                onTap: () {
                  _searchController.clear();
                  setState(() {
                    searchQuery = '';
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('estabelecimentos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var doc = docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      // Realiza a filtragem na lista localmente
                      if (searchQuery.isNotEmpty &&
                          !data['nome'].toLowerCase().contains(searchQuery)) {
                        return SizedBox.shrink();
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: isDarkTheme
                              ? Color.fromARGB(255, 36, 36, 36)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkTheme
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: data['imageUrl'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(data['imageUrl'],
                                      width: 50, height: 50, fit: BoxFit.cover),
                                )
                              : Icon(Icons.image,
                                  size: 50,
                                  color: isDarkTheme
                                      ? Colors.white
                                      : Colors.black54),
                          title: Text(
                            _capitalizeWords(data['nome']),
                            style: TextStyle(
                              color:
                                  isDarkTheme ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      size: 20,
                                      color: isDarkTheme
                                          ? Colors.white70
                                          : Colors.grey),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${data['endereco']}, ${data['numero']}',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PagEstabelecimentoReserve(
                                    estabelecimentoId: data['nome']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 45,
        color: isDarkTheme ? Colors.grey[950] : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home,
                    color: isDarkTheme ? Colors.white : Colors.black54),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.search,
                    color: isDarkTheme ? Colors.white : Colors.black54),
                onPressed: () {
                  //Navigator.pushReplacementNamed(context, '/search');
                },
              ),
            ),
            Expanded(
              child: IconBadge(
                icon: Icon(Icons.account_circle,
                    color: isDarkTheme ? Colors.white : Colors.black54),
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
            Expanded(
              child: IconButton(
                icon: Icon(Icons.settings,
                    color: isDarkTheme ? Colors.white : Colors.black54),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/settings');
                  // Implemente a navegação para a tela de Configurações
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalizeWords(String str) {
    if (str.isEmpty) return str;
    return str
        .toLowerCase()
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : word)
        .join(' ');
  }
}
