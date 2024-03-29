import 'package:flutter/material.dart';
import 'package:parkez/app_controller.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<String> _searchHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesquisar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _search(value);
              },
              decoration: InputDecoration(
                hintText: 'Buscar Estabelecimentos',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                  onTap: () {
                    _addToHistory(_searchResults[index]);
                    Navigator.of(context).pushNamed('/bk');
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 45,
        color: AppController.instance.isDarkTheme ? Colors.grey[950] : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Implemente a navegação para a tela de Pesquisa
                  Navigator.pushReplacementNamed(context, '/search');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/user');
                },
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.settings),
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

  void _search(String query) {
    // Simulação de uma pesquisa em uma base de dados
    List<String> mockData = [
      'teste' // Apenas um item cadastrado para teste
    ];

    // Limpa a lista de resultados de pesquisa
    _searchResults.clear();

    // Filtra os dados baseados na consulta
    for (String item in mockData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        _searchResults.add(item);
      }
    }

    // Atualiza a UI
    setState(() {});
  }

  void _addToHistory(String item) {
    // Adiciona o item ao histórico somente se ainda não estiver presente
    if (!_searchHistory.contains(item)) {
      _searchHistory.add(item);
      // Limita o histórico a 3 itens
      if (_searchHistory.length > 3) {
        _searchHistory.removeAt(0); // Remove o item mais antigo do histórico
      }
    }
  }
}
