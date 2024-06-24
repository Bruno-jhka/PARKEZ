import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkez/about_page.dart';
import 'package:parkez/controllers/app_controller.dart';
import 'package:parkez/estabelecimentos/Admin_estabelecimentos/AdminPage_establecimentos.dart';
import 'package:parkez/estabelecimentos/EstacionamentoPageReserve.dart';
import 'package:parkez/home_admin.dart';
import 'package:parkez/home_page.dart';
import 'package:parkez/Tela_sem_conexao.dart';
import 'package:parkez/card_payment_page.dart';
import 'package:parkez/search_page.dart';
import 'package:parkez/setting_page.dart';
import 'package:parkez/singup_page.dart';
import 'package:parkez/teste.dart';
import 'package:parkez/user_page.dart';
import 'login_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '_Comum/int_state.dart';
import 'package:parkez/Page_Carregamento.dart'; // Importa a nova página de carregamento

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IntState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  bool _isLoading = true; // Adicione um flag para a tela de carregamento

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
        _isLoading = false; // Atualize o flag após verificar a conectividade
      });
    });
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }
    setState(() {
      _connectivityResult = result;
      _isLoading = false; // Atualize o flag após verificar a conectividade
    });
  }

  void _retryConnection() {
    setState(() {
      _isLoading = true; // Atualize o flag antes de verificar novamente
    });
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Parkez',
          theme: ThemeData(
            primaryColor: Colors.black,
            hintColor: Colors.amber,
            brightness: AppController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => _isLoading // Verifica se está carregando
                ? LoadingScreen() // Exibe a tela de carregamento
                : _connectivityResult == ConnectivityResult.none
                    ? NoInternetScreen(onRetry: _retryConnection)
                    : RoteadorTela(),
            '/login': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/home_admin': (context) => HomeAdmin(),
            '/user': (context) => ProfilePage(),
            '/settings': (context) => SettingsPage(),
            '/about': (context) => AboutPage(),
            '/search': (context) => SearchPage(),
            '/signup': (context) => RegisterPage(),
            '/estabelecimentos/admVaga': (context) => AdminPage(),
          },
        );
      },
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        });
  }
}
