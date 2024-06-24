import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  final Function onRetry;

  NoInternetScreen({required this.onRetry});

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isRetrying = false;

  void _handleRetry() async {
    setState(() {
      _isRetrying = true;
    });

    // Simulate a delay for the loading animation
    await Future.delayed(Duration(seconds: 3));

    // Simulate retrying connection
    await widget.onRetry();

    setState(() {
      _isRetrying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isRetrying
              ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      color: Colors.orange,
                      size: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Oops!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sem conexão com a internet \nVerifique sua conexão com a internet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _handleRetry,
                      icon: Icon(Icons.refresh),
                      label: Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
