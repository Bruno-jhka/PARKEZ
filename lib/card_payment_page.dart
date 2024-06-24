import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:provider/provider.dart';
import 'package:parkez/controllers/app_controller.dart';
import '_Comum/int_state.dart';
import 'package:parkez/servicos/Database_card.dart';

class CardPaymentPage extends StatefulWidget {
  @override
  _CardPaymentPageState createState() => _CardPaymentPageState();
}

class _CardPaymentPageState extends State<CardPaymentPage> {
  late Future<List<Map<String, dynamic>>> _cards;

  @override
  void initState() {
    super.initState();
    _cards = DatabaseHelper().getCards();
  }

  void _addCard(Map<String, String> cardData) async {
    await DatabaseHelper().insertCard(cardData);
    setState(() {
      _cards = DatabaseHelper().getCards();
    });
  }

  void _deleteCard(int id) async {
    await DatabaseHelper().deleteCard(id);
    setState(() {
      _cards = DatabaseHelper().getCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final intState = Provider.of<IntState>(context);

    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;
    var buttonColor =
        isDarkMode ? Color.fromARGB(255, 36, 36, 36) : Colors.white;
    var shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.grey.withOpacity(0.5);
    var textColor = isDarkMode
        ? Color.fromARGB(137, 255, 255, 255)
        : Color.fromARGB(137, 0, 0, 0);
    var backgroundColor = isDarkMode ? Color(0xFF1F1F1F) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento com Cartão'),
      ),
      body: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _cards,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Nenhum cartão cadastrado');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var card = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: CardWidget(
                          cardNumber: card['cardNumber'] ?? '',
                          expiryDate: card['expiryDate'] ?? '',
                          cvv: card['cvv'] ?? '',
                          cardholderName: card['cardholderName'] ?? '',
                          cpf: card['cpf'] ?? '',
                          nickname: card['nickname'] ?? '',
                          onDelete: () => _confirmDeleteCard(card['id']),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddCardDialog();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor: backgroundColor, // Cor do texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: buttonColor), // Borda do botão
                ),
                elevation: 10, // Elevação para adicionar sombra
              ),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 48,
                child: Text(
                  'Adicionar Cartão',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
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
                    Navigator.pushReplacementNamed(context, '/settings');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final _cardNumberController = TextEditingController();
    final _expiryDateController = TextEditingController();
    final _cvvController = TextEditingController();
    final _cardholderNameController = TextEditingController();
    final _cpfController = TextEditingController();
    final _nicknameController = TextEditingController();

    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;
    var buttonColor = isDarkMode ? Color(0xFF242424) : Colors.white;
    var textColor = isDarkMode
        ? Color.fromARGB(137, 255, 255, 255)
        : Color.fromARGB(137, 0, 0, 0);
    var backgroundColor = isDarkMode ? Color(0xFF1F1F1F) : Colors.white;
    var shadowColor = Colors.black.withOpacity(0.5);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Adicionar Cartão',
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    hintText: 'Número do Cartão',
                    hintStyle: TextStyle(color: textColor),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CardNumberInputFormatter(),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _expiryDateController,
                  decoration: InputDecoration(
                    hintText: 'Validade (MM/AA)',
                    hintStyle: TextStyle(color: textColor),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ExpiryDateInputFormatter(),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _cvvController,
                  decoration: InputDecoration(
                    hintText: 'CVV',
                    hintStyle: TextStyle(color: textColor),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _cardholderNameController,
                  decoration: InputDecoration(
                    hintText: 'Nome do Titular',
                    hintStyle: TextStyle(color: textColor),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _cpfController,
                  decoration: InputDecoration(
                    hintText: 'CPF',
                    hintStyle: TextStyle(color: textColor),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CPFInputFormatter(),
                  ],
                ),
                SizedBox(height: 12),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    hintText: 'Apelido do Cartão',
                    hintStyle: TextStyle(color: textColor),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: buttonColor),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                elevation: MaterialStateProperty.all<double>(5.0),
                shadowColor: MaterialStateProperty.all<Color>(shadowColor),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: textColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_cardNumberController.text.isEmpty ||
                    _expiryDateController.text.isEmpty ||
                    _cvvController.text.isEmpty ||
                    _cardholderNameController.text.isEmpty ||
                    _cpfController.text.isEmpty ||
                    _nicknameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                    ),
                  );
                } else {
                  _addCard({
                    'cardNumber': _cardNumberController.text,
                    'expiryDate': _expiryDateController.text,
                    'cvv': _cvvController.text,
                    'cardholderName': _cardholderNameController.text,
                    'cpf': _cpfController.text,
                    'nickname': _nicknameController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: buttonColor),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                elevation: MaterialStateProperty.all<double>(5.0),
                shadowColor: MaterialStateProperty.all<Color>(shadowColor),
              ),
              child: Text(
                'Adicionar',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteCard(int id) {
    var theme = Theme.of(context);
    var isDarkMode = theme.brightness == Brightness.dark;
    var buttonColor = isDarkMode ? Color(0xFF242424) : Colors.white;
    var textColor = isDarkMode ? Colors.white : Colors.black;
    var backgroundColor = isDarkMode ? Color(0xFF1F1F1F) : Colors.white;
    var shadowColor = Colors.black.withOpacity(0.5);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirmação',
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          content: Text(
            'Você tem certeza que quer excluir este cartão?',
            style: TextStyle(color: textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: buttonColor),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                elevation: MaterialStateProperty.all<double>(5.0),
                shadowColor: MaterialStateProperty.all<Color>(shadowColor),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(color: textColor),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteCard(id);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: buttonColor),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                elevation: MaterialStateProperty.all<double>(5.0),
                shadowColor: MaterialStateProperty.all<Color>(shadowColor),
              ),
              child: Text(
                'Excluir',
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardWidget extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardholderName;
  final String cpf;
  final String nickname;
  final VoidCallback onDelete;

  CardWidget({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardholderName,
    required this.cpf,
    required this.nickname,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        image: DecorationImage(
          image: AssetImage('assets/card.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Numero do Cartão',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            cardNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nickname,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Validade: $expiryDate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.length > 16) {
      return oldValue;
    }
    final formattedText = _formatCardNumber(newText);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCardNumber(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i % 4 == 0 && i != 0) {
        buffer.write(' ');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.length > 4) {
      return oldValue;
    }
    final formattedText = _formatExpiryDate(newText);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatExpiryDate(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}

class CPFInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.length > 11) {
      return oldValue;
    }
    final formattedText = _formatCPF(newText);
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _formatCPF(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i == 3 || i == 6) {
        buffer.write('.');
      } else if (i == 9) {
        buffer.write('-');
      }
      buffer.write(input[i]);
    }
    return buffer.toString();
  }
}
